#!/bin/bash

source "$CONFIG_DIR/colors.sh"

if ! pgrep -x "MSTeams" >/dev/null 2>&1; then
  sketchybar --set teams_island drawing=off
  exit 0
fi

BADGE=$(osascript -e 'tell application "System Events" to tell process "Dock" to get value of attribute "AXStatusLabel" of (first UI element of list 1 whose name is "Microsoft Teams")' 2>/dev/null)

if [ -z "$BADGE" ] || [ "$BADGE" = "missing value" ]; then
  sketchybar --set teams_island drawing=on
  sketchybar --set teams label.drawing=off icon.color=$ICN_DIM
  exit 0
fi

sketchybar --set teams_island drawing=on
sketchybar --set teams label.drawing=on label="$BADGE" icon.color=$ICN_RED
