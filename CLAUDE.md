# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with **GNU Stow** on macOS. Each top-level directory is a stow package that mirrors the home directory structure. Configs use a consistent **Duckbones** theme across all tools.

## Managing Dotfiles

```bash
# Apply a config (creates symlinks from ~/dotfiles/<pkg>/** → ~/**)
stow <package>

# Remove a config's symlinks
stow -D <package>

# Apply all configs at once
stow */

# Install all Homebrew packages
brew bundle --file=brew/Brewfile
```

## Package Structure

Each directory follows GNU Stow conventions — files are placed relative to `$HOME`:

- `aerospace/` → `~/.config/aerospace/` — AeroSpace tiling window manager (TOML config + shell scripts)
- `brew/` → `~/` — Brewfile for all packages, casks, and VS Code extensions
- `btop/` → `~/.config/btop/` — System monitor with spaceduck theme
- `claude/` → `~/.claude/` — Claude Code settings, keybindings, and personal instructions
- `docker/` → `~/.docker/` — Docker CLI config with plugin paths (colima context)
- `ghostty/` → `~/.config/ghostty/` — Terminal emulator config with duckbones theme
- `git/` → `~/.config/git/` — Global gitignore (`.DS_Store`, `node_modules`, `.env.local`, etc.)
- `lazygit/` → `~/.config/lazygit/` — Lazygit config + `scripts/ai-commit.sh`
- `nvim/` → `~/.config/nvim/` — Neovim (LazyVim-based) with Lua plugins
- `planck/` → `~/` — Planck keyboard layouts (mac + ubuntu)
- `sketchybar/` → `~/.config/sketchybar/` — macOS status bar with aerospace + clock + battery
- `starship/` → `~/.config/` — Starship prompt (starship.toml)
- `tmux/` → `~/.config/tmux/` — Tmux config + vendored plugins (tpm, minimal-tmux-status, tmux-sensible)
- `zsh/` → `~/` — `.zshrc` with oh-my-zsh, fzf functions, project aliases

## Key Integrations

### AI Commit (lazygit)

`lazygit/scripts/ai-commit.sh` uses the `claude --print` CLI to generate conventional commit messages from staged diffs. Triggered in lazygit with `Ctrl+G` in commit message context — pipes output to clipboard. Requires the `claude` CLI to be authenticated.

### AeroSpace Workspace Layout

Apps are auto-assigned to workspaces:

- **1**: Terminal/Editor (Ghostty, VSCode, iTerm2)
- **2**: AI apps (ChatGPT, Claude)
- **3**: Finder/Preview
- **4**: Obsidian
- **5**: Browsers (Chrome, Arc)
- **7**: Media (Spotify, Music)
- **8**: Communication (Messages, WhatsApp, Teams)

`reset-workspaces.sh` is a helper script bound in aerospace service mode (`Alt+Shift+;` then `Shift+R`) to reassign all open windows back to their designated workspaces.

### Sketchybar

Bottom status bar (46px) with duckbones theme. Items:

- Workspace indicators (1-8) synced with AeroSpace via workspace change events
- Current app name (left)
- Clock (center, 30s refresh)
- Battery status (right, 120s refresh)

Plugins live in `sketchybar/.config/sketchybar/plugins/`.

### Neovim Plugin Architecture

LazyVim-based config in `nvim/.config/nvim/lua/plugins/`. Key plugins:

- **snacks.nvim** — dashboard, lazygit integration, file picker
- **conform.nvim** — formatting (Prettier for markdown)
- **lsp.lua** — ESLint with flat config support, Astro LSP
- **typescript-tools.nvim** — TypeScript LSP with inlay hints
- **harpoon** — file bookmarking (`<leader>ha` add, `<leader>hh` menu, `<leader>h1-4` jump)
- **neo-tree / oil** — file navigation
- **lualine** — statusline with duckbones colors
- **diffview.nvim** — git diff viewer
- **treesitter** — parsing for astro, tsx, typescript, lua, markdown, and more
- **nvim-ts-autotag** — auto-close JSX/HTML tags
- **tailwind.lua** — Tailwind CSS support

### Tmux Scripts

- `scripts/sesh-pick.sh` — interactive session picker using `sesh` + `gum filter`, bound to `prefix+s`
- `scripts/new-worktree.sh` — creates a git worktree for a branch with `gum filter`, opens new tmux window, bound to `prefix+w`

### Ghostty → Tmux Keybind Mapping

Ghostty maps `Cmd+key` combinations to tmux prefix sequences so tmux feels native on macOS:

- `Cmd+T/N/W` → new window / new session / kill pane
- `Cmd+D` / `Cmd+Shift+D` → split horizontal / vertical
- `Cmd+Arrow` → navigate panes
- `Cmd+1-9` → switch tmux windows
- `Cmd+Enter` → zoom pane

### Zsh Project System

`.zshrc` defines `project_cd <path> [use_nvm]` which changes directory, auto-detects the tech stack (Node, Rust, Go, Python), shows project info from `package.json`, and optionally calls `nvm use` if `.nvmrc` exists. Project shortcuts follow the pattern `p.<name>` (e.g. `p.spellbook`, `p.fwc`). Tmux variants are prefixed `t.p.<name>`.

FZF functions and aliases:

- `fp` / `Ctrl+P` — project switcher
- `ff` — file finder and editor
- `fcd` / `Ctrl+F` — directory navigator (eza tree preview)
- `fg` / `Ctrl+G` — live grep (ripgrep + fzf, opens result in nvim)
- `fb` — git branch switcher
- `fl` — git log browser
- `ft` — tmux session manager
- `fn` — npm script runner
- `fk` — kill process picker

### Config Aliases

Quick navigation aliases in `.zshrc`:

```
config.zsh       → edit .zshrc
config.dotfiles  → open ~/dotfiles in nvim
config.nvim      → open nvim config
config.tmux      → open tmux config
config.aerospace → open aerospace config
config.starship  → open starship config
config.ghostty   → open ghostty config
config.lazygit   → open lazygit config
```
