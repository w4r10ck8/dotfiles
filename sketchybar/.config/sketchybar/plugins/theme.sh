#!/bin/bash

# macOS fires the theme notification several times per switch; reload once per real change
[ "$SENDER" = theme_change ] || exit 0
THEME=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)
STATE=/tmp/sketchybar_theme_$USER
[ "$THEME" = "$(cat "$STATE" 2>/dev/null)" ] && exit 0
echo "$THEME" > "$STATE"
sketchybar --reload
