# dotfiles

Personal dotfiles managed with GNU Stow. Consistent **Duckbones** theme across all tools.

## Packages

| Package      | Destination             | Description                                        |
| ------------ | ----------------------- | -------------------------------------------------- |
| `aerospace`  | `~/.config/aerospace/`  | Tiling window manager with workspace automation    |
| `brew`       | `~/`                    | Brewfile — all packages, casks, VS Code extensions |
| `btop`       | `~/.config/btop/`       | System monitor (spaceduck theme)                   |
| `claude`     | `~/.claude/`            | Claude Code settings and keybindings               |
| `codex`      | `~/.codex/`             | Codex config and custom skills                     |
| `docker`     | `~/.docker/`            | Docker CLI config (colima context)                 |
| `ghostty`    | `~/.config/ghostty/`    | Terminal emulator config + keybinds                |
| `git`        | `~/.config/git/`        | Global gitignore                                   |
| `lazygit`    | `~/.config/lazygit/`    | Git TUI config + AI commit script                  |
| `nvim`       | `~/.config/nvim/`       | Neovim (LazyVim-based)                             |
| `planck`     | `~/`                    | Planck keyboard layouts (mac + ubuntu)             |
| `sketchybar` | `~/.config/sketchybar/` | macOS status bar                                   |
| `starship`   | `~/.config/`            | Shell prompt                                       |
| `tmux`       | `~/.config/tmux/`       | Terminal multiplexer config + plugins              |
| `zsh`        | `~/`                    | `.zshrc` — shell config, aliases, project system   |

## Setup

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Install Homebrew packages
brew bundle --file=brew/Brewfile

# Stow everything
stow */

# Or individual packages
stow zsh nvim tmux codex
```

## Usage

```bash
stow <package>      # apply (create symlinks)
stow -D <package>   # remove symlinks
stow */             # apply all
```

Edit config directly in `~/dotfiles/` — changes reflect immediately via symlinks.

## Codex Notes

The `codex/` package only tracks stable global configuration:

- `~/.codex/config.toml`
- custom skills in `~/.codex/skills/`

Runtime files such as auth, logs, history, sqlite databases, plugin caches, and session state stay unmanaged in the live `~/.codex/` directory.

Included custom skills:

- `jay-defaults` for Jay's default communication and engineering preferences
- `code-review` for findings-first review behavior
- `azure-pr-review-report` for Azure DevOps PR reviews written to `.reviews/PR-<number>-review.md`
