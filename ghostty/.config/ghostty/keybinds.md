# Ghostty Keybinds

All tmux binds are sent as `Ctrl+A` + key (tmux prefix).

## Global

| Key       | Action                |
| --------- | --------------------- |
| `Cmd+`` ` | Toggle quick terminal |

## Windows & Panes

| Key           | Action                                |
| ------------- | ------------------------------------- |
| `Cmd+T`       | New window (tmux `prefix + c`)        |
| `Cmd+N`       | New window (tmux `prefix + c`)        |
| `Cmd+W`       | Kill pane (tmux `prefix + x`)         |
| `Cmd+D`       | Split horizontal (tmux `prefix + \|`) |
| `Cmd+Shift+D` | Split vertical (tmux `prefix + -`)    |
| `Cmd+Enter`   | Zoom pane toggle (tmux `prefix + z`)  |

## Navigation

| Key           | Action                              |
| ------------- | ----------------------------------- |
| `Cmd+Left`    | Pane left (tmux `prefix + h`)       |
| `Cmd+Right`   | Pane right (tmux `prefix + l`)      |
| `Cmd+J`       | Pane down (tmux `prefix + j`)       |
| `Cmd+K`       | Pane up (tmux `prefix + k`)         |
| `Cmd+Shift+[` | Previous window (tmux `prefix + p`) |
| `Cmd+Shift+]` | Next window (tmux `prefix + n`)     |
| `Ctrl+Tab`    | Next window (tmux `prefix + n`)     |

## Sessions

| Key           | Action                             |
| ------------- | ---------------------------------- |
| `Cmd+Shift+N` | New session (tmux `prefix + N`)    |
| `Alt+Q`       | Detach session (tmux `prefix + d`) |

## Misc

| Key           | Action                                     |
| ------------- | ------------------------------------------ |
| `Cmd+,`       | Rename window (tmux `prefix + ,`)          |
| `Cmd+F`       | Find (tmux `prefix + F`)                   |
| `Cmd+/`       | Show tmux keybind help (tmux `prefix + ?`) |
| `Shift+Enter` | Send literal newline                       |
