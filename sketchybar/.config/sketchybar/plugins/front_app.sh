#!/bin/bash

ICON=$("$PLUGIN_DIR/icon_map.sh" "$INFO")
sketchybar --set "$NAME" icon="$ICON"
