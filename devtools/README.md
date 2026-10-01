# Development tools

This package owns personal workflow configuration. Deploy with:

```sh
stow --dir="$HOME/stow" --target="$HOME" --dotfiles --no-folding \
  --simulate --verbose devtools
stow --dir="$HOME/stow" --target="$HOME" --dotfiles --no-folding \
  --verbose devtools
```

`dot-config/devtask/projects.toml` is the registry for the upcoming task launcher.
It records independent Projects clones, explicit base branches, named context
membership, and the default agent/shell layout and brief handoff. There is no
`devtask` executable yet; task creation and Herdr integration are the next chunk.

Delivery policy values:

- `pr`: push the task branch and create a pull request when requested.
- `local`: integrate into the configured local target. Remote pushing is a
  separate step, and local-only projects may have no remote at all.
- `unspecified`: require a task-level choice before automated integration.

The `ai-services` repository has ticket/branch requirements in its AGENTS.md;
task creation must honor those instructions before choosing the task branch.

Context docs/configuration belong in `~/Projects/contexts/`, and generated task
files/state belong in `~/Projects/tasks/`. Neither is maintained by Stow.
Worktrunk's global configuration is unchanged by this package: future Projects
task paths must be chosen explicitly by the launcher, without changing how the
old dev checkouts create worktrees.
