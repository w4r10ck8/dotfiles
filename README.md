# dotfiles

Personal dotfiles managed with GNU Stow. Consistent **Duckbones** theme across all tools.

## Packages

| Package      | Destination             | Description                                        |
| ------------ | ----------------------- | -------------------------------------------------- |
| `aerospace`  | `~/.config/aerospace/`  | Tiling window manager with workspace automation    |
| `brew`       | `~/`                    | Brewfile — all packages, casks, VS Code extensions |
| `btop`       | `~/.config/btop/`       | System monitor (spaceduck theme)                   |
| `claude`     | `~/.claude/`            | Claude Code settings and keybindings               |
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
stow zsh nvim tmux
```

## Usage

```bash
stow <package>      # apply (create symlinks)
stow -D <package>   # remove symlinks
stow */             # apply all
```

Edit config directly in `~/dotfiles/` — changes reflect immediately via symlinks.
