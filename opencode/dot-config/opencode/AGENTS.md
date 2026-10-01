# Obsidian Vault

My Obsidian vault is located at `~/Documents/higharc`.

When asked to read from or write to Obsidian notes, use the standard file tools (Read, Write, Edit, Glob, Grep) to interact with markdown files in this directory instead of using the Obsidian MCP tools.

## Personal configuration source of truth

Personal dotfiles are maintained in ~/stow using GNU Stow.

Before changing personal tool configuration:
1. Resolve the runtime path's symlink and identify its maintained source.
2. Read ~/stow/AGENTS.md.
3. Edit the explicit source path under ~/stow, not the ~/.config alias.
4. Preserve runtime symlinks.
5. If configuration is not yet Stow-managed, identify that and propose adoption.

Tool-generated state stays at its runtime location. Project-specific configuration
and instructions should be edited in the owning project or context repository.
