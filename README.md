# My Dotfiles

Personal dotfiles managed with GNU Stow.

## Tools Configured

- **zsh**: Shell configuration with oh-my-zsh
- **nvim**: Neovim editor configuration
- **tmux**: Terminal multiplexer with plugins
- **lazygit**: Git TUI configuration
- **starship**: Cross-shell prompt
- **aerospace**: Window manager for macOS
- **ghostty**: Terminal emulator
- **brew**: Package management with Brewfile

## Setup Instructions

1. Clone this repository:

   ```bash
   git clone <repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Install GNU Stow:

   ```bash
   brew install stow
   ```

3. Install packages from Brewfile:

   ```bash
   brew bundle --file=brew/Brewfile
   ```

4. Stow the configurations you want:

   ```bash
   # Stow individual configs
   stow zsh
   stow nvim
   stow tmux
   stow lazygit
   stow starship
   stow aerospace
   stow ghostty

   # Or stow everything at once
   stow */
   ```

## Usage

- **Edit configs**: Make changes directly in the `~/dotfiles/` directory
- **Add new configs**: Create new folders and run `stow <folder-name>`
- **Remove configs**: Run `stow -D <folder-name>` to unlink

## Structure

```
dotfiles/
├── aerospace/          # Aerospace window manager config
├── brew/              # Homebrew package list
├── ghostty/           # Ghostty terminal config
├── lazygit/           # Lazygit configuration
├── nvim/              # Neovim configuration
├── starship/          # Starship prompt config
├── tmux/              # Tmux configuration and plugins
└── zsh/               # Zsh and Git configuration
```
