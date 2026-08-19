#!/bin/bash

sketchybar --add item cpu right \
  --set cpu \
  update_freq=5 \
  icon="$ACTIVITY" \
  icon.font="JetBrainsMono Nerd Font Mono:Regular:24.0" \
  icon.color=$ICN_DIM \
  label.color=$TEXT \
  script="$PLUGIN_DIR/cpu.sh"

sketchybar --add bracket right_island cpu clock clock_sep date \
  --set right_island \
  background.color=$PILL_BG \
  background.border_color=$PILL_BORDER \
  background.border_width=1 \
  background.corner_radius=8 \
  background.height=38 \
  background.drawing=on
