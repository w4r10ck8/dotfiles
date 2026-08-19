#!/usr/bin/env bash
# Layout: left 70% | right top 70% / right bottom 30%
# All panes open in current directory

tmux split-window -h -p 30 -c "#{pane_current_path}"
tmux split-window -v -p 30 -c "#{pane_current_path}"
tmux select-pane -L
