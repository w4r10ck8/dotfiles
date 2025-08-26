# Tmux Tokyo Night Configuration - Quick Reference

## 🎨 Theme Features

- **Tokyo Night color scheme** with dark purple/blue tones
- **Enhanced status bar** with system information
- **Custom pane borders** and window styling
- **Vim-style navigation** between panes

## ⌨️ Key Bindings

### Basic Commands

- `Ctrl-a` - Prefix key (instead of default Ctrl-b)
- `Prefix + r` - Reload tmux configuration
- `Prefix + I` - Install new plugins (TPM)

### Window Management

- `Ctrl-Shift-Left` - Previous window
- `Ctrl-Shift-Right` - Next window
- `Prefix + c` - Create new window
- `Prefix + &` - Kill current window

### Pane Management

- `Prefix + |` - Split window horizontally
- `Prefix + -` - Split window vertically
- `Ctrl-h/j/k/l` - Navigate between panes (vim-style)
- `Alt + Arrow Keys` - Resize panes

### Copy Mode & Selection

- `Prefix + [` - Enter copy mode
- `v` - Start selection (in copy mode)
- `y` - Copy selection (in copy mode)
- `Prefix + ]` - Paste

### Session Management

- `tmux new -s <name>` - Create new named session
- `tmux attach -t <name>` - Attach to session
- `tmux list-sessions` - List all sessions
- `Prefix + d` - Detach from session

## 🔌 Installed Plugins

- **TPM** - Tmux Plugin Manager
- **tmux-sensible** - Basic tmux improvements
- **vim-tmux-navigator** - Seamless vim/tmux navigation
- **tmux-yank** - Copy to system clipboard
- **tmux-resurrect** - Save/restore tmux sessions
- **tmux-continuum** - Automatic session saving
- **tmux-tokyo-night** - Tokyo Night theme

## 🎯 Tips

- Use `tmux attach` to reconnect to your last session
- Sessions persist even when terminal is closed
- Use multiple windows for different projects
- Copy mode works like vim - `h/j/k/l` for navigation
