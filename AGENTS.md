## Stow configuration ownership

- Maintain personal configuration by editing source paths under ~/stow.
- Before editing a runtime path, resolve its symlink and identify its Stow source.
- Do not replace runtime symlinks with regular files.
- Read the affected package's existing configuration before changing it.
- Packages use dot- names, deployed with --dotfiles.
- Use --no-folding for packages whose runtime directories also contain generated state.
- Dry-run affected packages before deployment:
  stow --dir="$HOME/stow" --target="$HOME" --dotfiles --no-folding --simulate --verbose PACKAGE
- Deploy only affected packages; do not restow every package.
- Keep logs, sockets, sessions, caches, credentials, installed dependencies,
  and generated plugin registries out of version control.
- Preserve machine-specific and platform-specific behavior.
- Validate configurations and explain required reloads or restarts.
- Project instructions and shared project knowledge belong in their repository
  or context repository. Generated task files belong in the task directory.
- Do not commit or push unless requested.
