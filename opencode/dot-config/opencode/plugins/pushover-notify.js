export const PushoverNotify = async ({ client, directory, worktree }) => {
  const token = process.env.PUSHOVER_APP_TOKEN
  const user = process.env.PUSHOVER_USER_KEY

  const basename = (path) => {
    if (!path) return undefined
    const parts = path.split("/").filter(Boolean)
    return parts.at(-1)
  }

  const projectName = basename(worktree) || basename(directory) || "unknown"
  const sessions = new Map()

  const sessionState = (sessionID) => {
    if (!sessionID) return undefined
    if (!sessions.has(sessionID)) {
      sessions.set(sessionID, {
        title: undefined,
        parentID: undefined,
        messages: new Map(),
        parts: new Map(),
      })
    }
    return sessions.get(sessionID)
  }

  const eventValue = (event, paths) => {
    for (const path of paths) {
      let value = event
      for (const key of path) {
        value = value?.[key]
      }
      if (value !== undefined && value !== null && value !== "") return value
    }
    return undefined
  }

  const unwrap = (result) => result?.data ?? result

  const clip = (value, max = 650) => {
    const text = String(value || "").replace(/\s+\n/g, "\n").trim()
    if (text.length <= max) return text

    const head = text.slice(0, 260).trimEnd()
    const tail = text.slice(-(max - head.length - 20)).trimStart()
    return `${head}\n...\n${tail}`
  }

  const escapeHtml = (value) => {
    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;")
  }

  const appendField = (lines, label, value, max = 160) => {
    if (value === undefined || value === null || value === "") return
    lines.push(`<b>${escapeHtml(label)}:</b> ${escapeHtml(clip(value, max))}`)
  }

  const appendBlock = (lines, label, value, max = 480) => {
    if (value === undefined || value === null || value === "") return
    lines.push(`<b>${escapeHtml(label)}:</b>\n${escapeHtml(clip(value, max))}`)
  }

  const textFromMessage = (message) => {
    const text = message?.parts
      ?.filter((part) => part.type === "text" && !part.synthetic && part.text)
      .map((part) => part.text)
      .join("\n")

    return text || message?.info?.summary?.body
  }

  const textFromCachedMessage = (state, message) => {
    const parts = state.parts.get(message.info.id)
    if (parts?.size) return [...parts.values()].join("\n")
    return message.info?.summary?.body
  }

  const latestMessage = (messages, role) => {
    return messages
      .filter((message) => message.info?.role === role)
      .sort((a, b) => (b.info?.time?.created || 0) - (a.info?.time?.created || 0))[0]
  }

  const updateCache = (event) => {
    if (event.type === "session.updated" || event.type === "session.created") {
      const state = sessionState(event.properties?.sessionID)
      if (state) {
        state.title = event.properties?.info?.title || state.title
        state.parentID = event.properties?.info?.parentID || state.parentID
      }
      return
    }

    if (event.type === "message.updated") {
      const state = sessionState(event.properties?.sessionID)
      const info = event.properties?.info
      if (state && info?.id) state.messages.set(info.id, { info })
      return
    }

    if (event.type === "message.part.updated") {
      const part = event.properties?.part
      const state = sessionState(event.properties?.sessionID || part?.sessionID)
      if (!state || part?.type !== "text" || part.synthetic || !part.text) return

      if (!state.parts.has(part.messageID)) state.parts.set(part.messageID, new Map())
      state.parts.get(part.messageID).set(part.id, part.text)
    }
  }

  const cachedSessionContext = (sessionID) => {
    const state = sessions.get(sessionID)
    if (!state) return {}

    const latestAssistant = latestMessage([...state.messages.values()], "assistant")
    return {
      title: state.title,
      parentID: state.parentID,
      result: latestAssistant ? textFromCachedMessage(state, latestAssistant) : undefined,
    }
  }

  const sessionContext = async (event) => {
    const sessionID = eventValue(event, [["properties", "sessionID"], ["sessionID"], ["sessionId"]])
    if (!sessionID) return {}

    const cached = cachedSessionContext(sessionID)
    if (cached.title && cached.result) return cached

    try {
      const [sessionResult, messagesResult] = await Promise.all([
        client.session.get({ sessionID, directory }),
        client.session.messages({ sessionID, directory, limit: 8 }),
      ])

      const session = unwrap(sessionResult)
      const messages = unwrap(messagesResult) || []
      const latestAssistant = latestMessage(messages, "assistant")
      const latestText = textFromMessage(latestAssistant)

      return {
        title: cached.title || session?.title,
        parentID: cached.parentID || session?.parentID,
        result: cached.result || latestText,
      }
    } catch (error) {
      await client.app.log({
        body: {
          service: "pushover-notify",
          level: "warn",
          message: `Could not load session context for Pushover notification: ${error?.message || error}`,
        },
      })
      return {}
    }
  }

  const buildMessage = async (event, summary, extras = [], contextLabel = "Result", loadedContext) => {
    const context = loadedContext || await sessionContext(event)
    const header = `<b>${escapeHtml(summary)}</b>`
    const metadata = []
    const detail = []

    appendField(metadata, "Project", projectName)
    appendField(metadata, "Session", context.title, 180)

    for (const [label, value] of extras) {
      appendField(detail, label, value, 220)
    }

    const sections = [header]
    if (metadata.length) sections.push(metadata.join("\n"))
    if (detail.length) sections.push(detail.join("\n"))

    const contextSection = []
    appendBlock(contextSection, contextLabel, context.result)
    if (contextSection.length) sections.push(contextSection.join("\n"))

    return sections.join("\n\n")
  }

  const notify = async ({ title, message, priority = 0 }) => {
    if (!token || !user) {
      await client.app.log({
        body: {
          service: "pushover-notify",
          level: "warn",
          message: "Pushover notifications skipped; PUSHOVER_APP_TOKEN or PUSHOVER_USER_KEY is missing.",
        },
      })
      return
    }

    const response = await fetch("https://api.pushover.net/1/messages.json", {
      method: "POST",
      headers: { "content-type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        token,
        user,
        title,
        message,
        html: "1",
        priority: String(priority),
      }),
    })

    if (!response.ok) {
      await client.app.log({
        body: {
          service: "pushover-notify",
          level: "warn",
          message: `Pushover notification failed with HTTP ${response.status}.`,
        },
      })
    }
  }

  return {
    event: async ({ event }) => {
      updateCache(event)

      if (event.type === "permission.asked") {
        await notify({
          title: "opencode needs permission",
          message: await buildMessage(event, "Permission is required to continue.", [
            ["Permission", eventValue(event, [["properties", "permission"]])],
            ["Patterns", eventValue(event, [["properties", "patterns"]])?.join?.(", ")],
          ], "Context"),
          priority: 1,
        })
        return
      }

      if (event.type === "session.idle") {
        const context = await sessionContext(event)
        if (context.parentID) return

        await notify({
          title: "opencode",
          message: await buildMessage(event, "Task finished.", [], "Result", context),
        })
        return
      }

      if (event.type === "session.error") {
        await notify({
          title: "opencode error",
          message: await buildMessage(event, "A session hit an error.", [
            ["Error", eventValue(event, [["properties", "error", "data", "message"], ["properties", "error", "message"], ["properties", "error", "name"]])],
          ]),
          priority: 1,
        })
      }
    },
  }
}
