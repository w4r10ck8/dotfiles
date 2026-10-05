#!/bin/bash

sketchybar --add item front_app left \
  --set front_app \
    icon.font="sketchybar-app-font:Regular:18.0" \
    icon.color=$ICN_RED \
    label.drawing=off \
    background.drawing=off \
    script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched

# Stack position (e.g. 2/4) when the focused window is in a yabai stack.
# Stands in for aerospace's accordion-padding peek, which yabai can't do.
sketchybar --add item stack left \
  --set stack \
    icon.drawing=off \
    label.color=$ICN_DIM \
    drawing=off \
    script="$PLUGIN_DIR/stack.sh" \
  --subscribe stack window_focus front_app_switched space_change
