# Development tools

This package owns personal workflow configuration. Deploy with:

```sh
stow --dir="$HOME/stow" --target="$HOME" --dotfiles --no-folding \
  --simulate --verbose devtools
stow --dir="$HOME/stow" --target="$HOME" --dotfiles --no-folding \
  --verbose devtools
```

`dot-local/bin/devtask` is a Python 3.11+ CLI using Git, Worktrunk, and the installed
Herdr CLI. `dot-config/devtask/projects.toml` owns the project registry. Both are
maintained here and deployed as symlinks, not edited through runtime aliases.

## Create tasks

Run from any directory inside Herdr:

```sh
# A new task branch from product's locally available develop.
devtask new product auth --prompt 'Implement authentication; report tests and the diff.'

# Two selected writable repos in a context; integration policy is explicit.
devtask new kinfra ingress --repos infra,gitops --delivery local \
  --prompt-file /path/to/brief.md

# Only infra is writable; gitops is supporting context.
devtask new kinfra network --repos infra --references gitops

# A child task off an existing feature, to integrate back into that feature.
devtask new product auth-api --base feature/auth --target feature/auth

# Per-repository choices can be repeated; a plain value applies to all selections.
devtask new kinfra coordinated --repos infra,gitops \
  --base infra=main --base gitops=feature/platform \
  --target gitops=feature/platform --delivery infra=local --delivery gitops=pr

# Ticketed ai-services branch; resolve the ticket and required base freshness first.
devtask new ai-services service-fix --branch labsrd-849-service-fix
```

Task slugs are lowercase letters, digits, hyphens or underscores (max 64).
Branches default to `task/<project>/<task>`, except repositories with naming
constraints must satisfy their configured pattern. New branches only: an existing
branch is not silently changed or repurposed. Fork another task from it using
`--base`; `open` reuses an environment created by this launcher.

Each task lives at `~/Projects/tasks/<project>/<task>/`, with one child worktree
per writable repository. Single-repo agents and shells start inside that worktree;
multi-repo agents and shells start at the task root. Multi-repo shells can `cd infra`
or `cd gitops` for Git/Neovim commands. Metadata, instructions and the handoff are
outside the Git worktrees, so task setup does not dirty application repositories.

Worktrunk gets an explicit per-invocation worktree path; global defaults and old
dev checkouts are unaffected. Bases are resolved to local commit SHAs before
creation. No implicit fetch, credentials/environment copy, dependency sharing,
LFS download, commit, merge or push happens. Setup hooks are skipped by default;
`--hooks` enables the repository's Worktrunk hooks and normal approval flow.

## Navigate and reopen

```sh
devtask projects
devtask list
devtask list kinfra
devtask open kinfra ingress --focus
cd "$(devtask path product auth)"
gs
```

Creation and reopening preserve current focus unless `--focus` is supplied.
`open` reuses the task's space and named OpenCode agent. It resumes a captured
session ID after an agent exits, and does not replay the original handoff on each
open. `--agent` and `--model` can override task defaults for a new/resumed process.

`--no-agent` creates/reopens an agent/shell layout without starting or prompting
OpenCode. `new --no-open` creates worktrees/files without contacting Herdr and also
works outside a Herdr pane. Use `devtask --json COMMAND ...` for structured output
or `devtask --config FILE COMMAND ...` for another registry.

## OpenCode handoff

The global `/task` command is maintained in the OpenCode Stow package:

```text
/task kinfra ingress --repos infra,gitops --delivery local Implement public ingress using the approach we discussed.
```

The current agent resolves scope, follows repository-specific task-start rules,
writes a brief handoff, and launches a fresh session in the task's space. Restart
OpenCode after deploying the command. Generated task configuration is selected
with `OPENCODE_CONFIG`; it supplements repository instructions and gives named
references to exactly the chosen worktrees, optional consult-only repos, and
shared context docs. Canonical/reference-only repositories are consult-only by
instruction and canonical edits are denied through OpenCode's edit permissions.
This is not an OS sandbox; shell commands still require scope discipline.

If automatic dispatch has an uncertain acknowledgment, reopen will not replay it.
Inspect the destination before explicitly retrying with `open --prompt-file FILE`.
An explicit prompt on `open` submits a new instruction to the live agent.

## Recovery and state

`.devtask.json` records repository branches, base commits, targets, delivery policy,
and per-Herdr-endpoint layout/session state. Do not move task directories manually;
Git worktree registrations and this metadata contain absolute paths.

All repositories are preflighted before mutation. If later creation fails, completed
worktrees are retained and metadata is marked `incomplete`; inspect it and resolve
the failure deliberately rather than deleting user work or rerunning `new` blindly.
An agent-launch failure leaves a ready environment that `open` can recover.

Delivery policy values:

- `pr`: push the task branch and create a pull request when requested.
- `local`: integrate into the configured local target. Remote pushing is a
  separate step, and local-only projects may have no remote at all.
- `unspecified`: require a task-level choice before automated integration.

The `ai-services` repository has ticket/branch requirements in its AGENTS.md.
The launcher checks branch shape, not Linear ticket existence or remote freshness;
the caller must follow the repo's start-work rules before choosing the branch.

Context docs/configuration belong in `~/Projects/contexts/`, and generated task
files/state belong in `~/Projects/tasks/`. Neither is maintained by Stow.
## Verification

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s devtools/tests -v
```

Tests use temporary Git repos and real Worktrunk for task creation. Herdr protocol
fixtures cover prompt dispatch, focus preservation, reopen/resume, and failure
handling. Runtime smoke checks should use a disposable named Herdr session.
