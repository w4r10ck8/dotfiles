#!/bin/bash

WINDOW=$(yabai -m query --windows --window 2>/dev/null)
INDEX=$(echo "$WINDOW" | jq -r '."stack-index" // 0')

if [ "$INDEX" = "0" ] || [ -z "$INDEX" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Stacked windows share the focused window's frame
TOTAL=$(yabai -m query --windows --space | jq --argjson frame "$(echo "$WINDOW" | jq '.frame')" \
  '[.[] | select(.frame == $frame and ."stack-index" > 0)] | length')

sketchybar --set "$NAME" drawing=on label="$INDEX/$TOTAL"
