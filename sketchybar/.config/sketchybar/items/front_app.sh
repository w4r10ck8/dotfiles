#!/bin/bash

sketchybar --add item front_app left \
  --set front_app \
    icon.drawing=off \
    label.font="JetBrainsMono Nerd Font Mono:Bold:13.0" \
    background.drawing=on \
    background.color=$PILL_BG \
    background.border_color=$PILL_BORDER \
    background.border_width=1 \
    background.corner_radius=8 \
    background.height=38 \
    script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
