#!/bin/bash

sketchybar --add item date right \
  --set date \
    update_freq=60 \
    icon.drawing=off \
    label.color=$TEXT \
    script="$PLUGIN_DIR/date.sh"
