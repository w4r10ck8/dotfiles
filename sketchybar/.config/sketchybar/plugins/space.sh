#!/bin/bash

source "$CONFIG_DIR/colors.sh"

WS=$(echo "$NAME" | sed 's/space\.//')

if [ -n "$FOCUSED" ]; then
    CURRENT="$FOCUSED"
else
    CURRENT=$(aerospace list-workspaces --focused 2>/dev/null)
fi

if [ "$WS" = "$CURRENT" ]; then
    ICON_COLOR=$ICN_RED
else
    ICON_COLOR=$ICN_INACTIVE
fi

LABEL=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  LABEL+=" $("$PLUGIN_DIR/icon_map.sh" "$app")"
done <<< "$(aerospace list-windows --workspace "$WS" --format '%{app-name}' 2>/dev/null)"

if [ -n "$LABEL" ]; then
    sketchybar --animate tanh 20 --set "$NAME" icon.color="$ICON_COLOR" label="$LABEL" label.drawing=on
else
    sketchybar --animate tanh 20 --set "$NAME" icon.color="$ICON_COLOR" label.drawing=off
fi
