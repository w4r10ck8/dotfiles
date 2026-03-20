#!/bin/bash

WS=$(echo "$NAME" | sed 's/space\.//')

if [ -n "$FOCUSED" ]; then
    CURRENT="$FOCUSED"
else
    CURRENT=$(aerospace list-workspaces --focused 2>/dev/null)
fi

if [ "$WS" = "$CURRENT" ]; then
    sketchybar --set "$NAME" \
        icon.color=0xff00a3cb \
        icon.font="JetBrainsMono Nerd Font Mono:Bold:14.0"
else
    sketchybar --set "$NAME" \
        icon.color=0xff444860 \
        icon.font="JetBrainsMono Nerd Font Mono:Medium:14.0"
fi
