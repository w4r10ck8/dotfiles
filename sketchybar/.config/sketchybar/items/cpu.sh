#!/bin/bash

sketchybar --add item cpu right \
  --set cpu \
    update_freq=5 \
    icon="$ACTIVITY" \
    icon.font="SF Pro:Regular:14.0" \
    icon.color=$ICN_DIM \
    label.color=$TEXT \
    script="$PLUGIN_DIR/cpu.sh"

sketchybar --add bracket stats battery cpu \
  --set stats \
    background.color=$PILL_BG \
    background.border_color=$PILL_BORDER \
    background.border_width=1 \
    background.corner_radius=8 \
    background.height=38 \
    background.drawing=on
