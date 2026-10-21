---
description: Close out this conversation and remove only safely preserved task worktrees
agent: build
subagent: false
---

Close out this conversation. Inspect its worktrees, remove them only if safe,
and visibly mark this conversation done. This invocation authorizes safe removal
of this task's worktrees and, when necessary, moving THIS session out of a
worktree before removing it. It does not authorize deletion of branches,
commits, sessions, secrets, or other tasks' directories.

Optional scope or additional constraints: $ARGUMENTS

## Scope and handoff

1. Use this conversation and applicable AGENTS.md files to identify the exact
   task-owned worktree paths, repositories, branches, base refs, integration
   targets, PRs, checks, and remaining delivery steps. Do not assume every
   worktree in the project belongs to this conversation. If ownership is
   ambiguous, ask before removing anything.
2. Inspect the current working directory and each repo's `git worktree list
   --porcelain`. Honor context symlinks and multi-repo task-folder layouts.
   Never remove a base checkout, repository root, shared symlink, or an unrelated
   task. If this task's worktrees are already absent and unregistered, removal
   is a successful no-op; do not broadly prune unrelated registrations.
3. Give a concise handoff: outcome, PRs, validation, and any pending CI, reviews,
   merge, deployment, or operational acceptance. Do not invent runtime success.
   Do not commit, push, merge, deploy, or apply infrastructure just to clean up.

## Required safety checks (for EVERY candidate before any removal)

- Run Git from that exact repository. Record HEAD, branch, registration,
  locked/prunable state, and `git status --porcelain=v1 --untracked-files=all`.
  Stop for tracked modifications, staged changes, untracked user files, active
  rebase/merge/cherry-pick/revert, conflicted files, locked worktrees, or submodules
  that make removal ambiguous. Never reset, stash, clean, unlock, or force removal.
- Inspect ignored files too (`git ls-files --others --ignored --exclude-standard`).
  A clean status is not proof that ignored files are disposable. Never delete
  secrets, environment files, local reports, screenshots, notes, databases, or
  other user data. Only known reproducible dependency/build caches may be treated
  as disposable, after identifying them. Unknown ignored content blocks removal.
- Confirm the work is preserved remotely. Fetch the relevant remote without
  changing a checkout, then prove HEAD is reachable from a remote branch or a
  verified remote tag, or belongs to a merged PR whose head SHA matches this
  worktree's HEAD. Account for squash merges; do not rely solely on ancestry
  against main. A matching pushed open PR is preservation, not proof of merge.
  Unpushed commits, detached work without preservation, failed fetches, or uncertain
  provenance block removal. Keep all local and remote branches regardless.
- Check session ownership and activity using available OpenChamber tools.
  Inspect all sessions linked to the candidate, not just the newest few. Other
  non-archived sessions using the worktree, running agents, shared terminals or
  dev servers, and unclear activity block removal. Do not stop someone else's
  work. If activity cannot be checked reliably, ask rather than claim safety.
- For a coordinated multi-repo task, finish all safety checks first. If any
  candidate is unsafe, keep the task intact and report the blocker; do not
  partially remove its worktrees by default.

## Removal

1. If THIS session is rooted inside a candidate, move it to the existing owning
   context/task parent or primary checkout using the supported session-move
   tool BEFORE deletion. This command explicitly requests that move only for
   the current session. Never migrate unrelated sessions or create a new session.
   Keep context-rooted sessions in their context. If the move fails, stop.
2. Recheck status and HEAD immediately before removal; abort if anything changed.
3. From the owning repo's surviving checkout, run `git worktree remove` with
   the exact candidate path and WITHOUT `--force`. On failure, stop and report
   it; never escalate to recursive deletion, prune, or Git metadata surgery.
4. Verify both the directory and its Git registration are gone. Leave task-folder
   AGENTS.md, reports and other files intact. An actually empty wrapper directory
   may be removed with `rmdir`, never `rm -rf`.

## Mark this conversation done

- Do this only after cleanup succeeded, was a verified no-op, or the user
  explicitly chose to finish while retaining blocked worktrees. An unresolved
  cleanup blocker is NOT a successful closeout.
- Prefer a supported agent-accessible OpenChamber action for its native Done
  state, if the installed version exposes one. Verify the result. Do not invent
  an action/API, edit OpenChamber state files/databases, extract credentials,
  archive/delete the conversation, or use private UI endpoints to bypass the
  tool's permissions.
- Currently the OpenChamber agent tool and CLI do not expose native Done.
  When unavailable, use the supported OpenCode session-rename tool to title
  THIS conversation `[Done] <short task summary>` (preserve its original title
  when known; do not duplicate the prefix). Default to the current session,
  never guess its ID from the most recent session in a list. Report this as a
  visible title marker ONLY, and tell the user to click OpenChamber's native
  Done toggle if they want that state set. If rename is unavailable, explicitly
  report that the conversation was not marked done.
- In the final answer report exact worktrees removed/retained, preservation/PR
  status, any pending delivery work, and whether native Done or only the title
  marker was set. Keep it brief. Never claim that invoking this command here
  has closed out some other conversation.
