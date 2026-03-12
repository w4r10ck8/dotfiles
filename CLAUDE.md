# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with **GNU Stow** on macOS. Each top-level directory is a stow package that mirrors the home directory structure. Configs use a consistent **Tokyo Night** theme across all tools.

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
- `docker/` → `~/.docker/` — Docker CLI config with plugin paths
- `ghostty/` → `~/.config/ghostty/` — Terminal emulator config
- `lazygit/` → `~/.config/lazygit/` — Lazygit config + `scripts/ai-commit.sh`
- `nvim/` → `~/.config/nvim/` — Neovim (LazyVim-based) with Lua plugins
- `starship/` → `~/.config/` — Starship prompt (starship.toml)
- `tmux/` → `~/.config/tmux/` — Tmux config + vendored plugins (tpm, tokyo-night, resurrect, continuum, yank, vim-tmux-navigator)
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

`reset-workspaces.sh` and `chatgpt-float.sh` are helper scripts for the service mode keybinding.

### Neovim Plugin Architecture

LazyVim-based config in `nvim/.config/nvim/lua/plugins/`. Key plugins:

- **snacks.nvim** — dashboard, lazygit integration, file picker
- **conform.nvim** — formatting
- **typescript-tools.nvim** — TypeScript LSP
- **harpoon** — file bookmarking
- **neo-tree / oil** — file navigation
- **lualine** — statusline with Tokyo Night colors

### Zsh Project System

`.zshrc` defines `project_cd <path> [use_nvm]` which changes directory and optionally calls `nvm use` if `.nvmrc` exists. Project shortcuts follow the pattern `p.<name>` (e.g. `p.spellbook`, `p.fwc`). Tmux variants are prefixed `t.p.<name>`.

FZF widgets are bound to:

- `Ctrl+P` — project switcher
- `Ctrl+F` — file finder (with bat preview)
- `Ctrl+G` — live grep (ripgrep + fzf)

### Config Aliases

Quick navigation aliases in `.zshrc`:

```
config.zsh       → edit .zshrc
config.dotfiles  → open ~/dotfiles in nvim
config.nvim      → open nvim config
config.tmux      → open tmux config
config.aerospace → open aerospace config
```
