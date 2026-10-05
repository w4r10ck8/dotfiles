#!/bin/bash

WS=$1

# On event: $FOCUSED env var is set by the trigger
# On initial load: query aerospace directly
if [ -n "$FOCUSED" ]; then
    CURRENT="$FOCUSED"
else
    CURRENT=$(aerospace list-workspaces --focused 2>/dev/null)
fi

if [ "$WS" = "$CURRENT" ]; then
    sketchybar --set "$NAME" \
        label.color=0xff0e101a \
        background.color=0xff00a3cb
else
    sketchybar --set "$NAME" \
        label.color=0xff444860 \
        background.color=0xff161829
fi
