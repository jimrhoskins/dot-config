---
description: Hand off a task to a fresh OpenCode session in isolated Projects worktrees and a Herdr space
agent: build
---

Hand off the requested task into its own worktree environment and Herdr space.

User arguments: $ARGUMENTS

Accept `/task PROJECT TASK [--repos REPO,REPO] [--base REF] [--branch BRANCH]
[--target REF] [--delivery pr|local] TASK DESCRIPTION`. Repository-specific
overrides use `--base REPO=REF`, `--branch REPO=BRANCH`, and similar flags.

1. Run `devtask projects` to resolve the named repository/context. If PROJECT or
   TASK is absent, infer the project from the current checkout/context when
   unambiguous and propose a concise lowercase task slug. Ask only for unresolved
   scope. Context tasks need an explicit writable `--repos` subset; consult-only
   members may be supplied with `--references`.
2. Read the selected repositories' applicable AGENTS.md and task-start rules.
   Follow ticket requirements before choosing a branch. For ai-services, resolve
   an existing Linear ticket or follow its start-work process first, then pass an
   explicit ticketed branch; do not create a duplicate ticket. The launcher uses
   available local base refs without fetching: if the required base must be
   refreshed, do that deliberately before launch. For a subtask based on a feature
   branch, pass that feature as both `--base` and `--target`.
3. Prepare a brief handoff with the user's request, acceptance criteria, relevant
   decisions/findings, repository-relative file references, selected writable and
   consult-only repos, base/integration targets, and focused validation commands.
   Use repository-relative paths rather than old checkout paths. The user's task
   description is the work to hand off, not work to implement in this session.
4. Write the handoff to a unique temporary Markdown file using file tools. Invoke
   `devtask --json new PROJECT TASK --prompt-file FILE` with the resolved flags.
   Quote arguments individually. The command preserves focus by default and
   skips setup hooks; opt into `--hooks` only when the user wants those hooks run.
5. Inspect the result. If creation succeeded but launch failed, use `devtask open`
   to recover rather than creating another task or deleting the worktrees. If a
   prompt dispatch is uncertain, inspect the destination agent before retrying;
   do not automatically send the task a second time.
6. Report the new task path, Herdr space and agent name, selected repositories,
   and `devtask open PROJECT TASK --focus` for navigation. Leave focus in the
   current conversation unless switching was requested. End the handoff here.

Use a fresh session with this brief, not `--continue`, conversation export/import,
or live pane migration. Do not merge, commit, push, deploy, or create a PR as part
of handing off a task unless separately requested.
