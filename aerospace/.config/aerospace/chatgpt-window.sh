#!/bin/bash

# ChatGPT (com.openai.codex) window router, run from on-window-detected.
# Main window tiles on workspace 2. Quick chat floats, but its hotkey activates
# ChatGPT, which drags focus to workspace 2 first. If that jump just happened,
# send quick chat back to the workspace we came from.

state=/tmp/aerospace-last-ws-change # "<prev> <focused>", written by exec-on-workspace-change

sleep 0.3 # let AeroSpace settle the window's layout

read -r prev focused <"$state" 2>/dev/null
age=$(($(date +%s) - $(stat -f %m "$state" 2>/dev/null || echo 0)))

aerospace list-windows --monitor all --app-bundle-id com.openai.codex \
  --format '%{window-id} %{window-layout} %{workspace}' |
  while read -r id layout ws; do
    if [ "$layout" != floating ]; then
      aerospace move-node-to-workspace --window-id "$id" 2
    elif [ "$ws" = 2 ] && [ "$focused" = 2 ] && [ -n "$prev" ] && [ "$prev" != 2 ] && [ "$age" -le 2 ]; then
      aerospace move-node-to-workspace --window-id "$id" "$prev"
      aerospace workspace "$prev"
      aerospace focus --window-id "$id"
    fi
  done
