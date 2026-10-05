#!/bin/bash

source "$CONFIG_DIR/colors.sh"

WS=$(echo "$NAME" | sed 's/space\.//')

SPACE=$(yabai -m query --spaces --space "$WS" 2>/dev/null)

if [ "$(echo "$SPACE" | jq -r '."has-focus"')" = "true" ]; then
    ICON_COLOR=$ICN_FG
else
    ICON_COLOR=$ICN_INACTIVE
fi

LABEL=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  LABEL+=" $("$PLUGIN_DIR/icon_map.sh" "$app")"
done <<< "$(yabai -m query --windows --space "$WS" 2>/dev/null | jq -r '.[] | select(."is-minimized" or ."is-hidden" or ."is-sticky" | not) | .app')"

if [ -n "$LABEL" ]; then
    sketchybar --animate tanh 20 --set "$NAME" icon.color="$ICON_COLOR" label="$LABEL" label.color="$ICON_COLOR" label.drawing=on
else
    sketchybar --animate tanh 20 --set "$NAME" icon.color="$ICON_COLOR" label.drawing=off
fi
