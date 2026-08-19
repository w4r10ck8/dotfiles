#!/bin/bash

sketchybar --add item clock_sep right \
  --set clock_sep \
    icon.drawing=off \
    label="|" \
    label.color=$TEXT_DIM \
    padding_left=2 \
    padding_right=2 \
    label.padding_left=0 \
    label.padding_right=0

sketchybar --add item clock right \
  --set clock \
    update_freq=30 \
    icon.drawing=off \
    label.color=$TEXT \
    script="$PLUGIN_DIR/clock.sh"
