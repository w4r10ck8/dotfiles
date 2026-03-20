#!/bin/bash

PERCENTAGE=$(pmset -g batt | grep -Eo '\d+%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c 'AC Power')

if [ "$CHARGING" -gt 0 ]; then
    ICON=""
    COLOR=0xff5dcd97
elif [ "$PERCENTAGE" -ge 50 ]; then
    ICON=""
    COLOR=0xff5dcd97
elif [ "$PERCENTAGE" -ge 20 ]; then
    ICON=""
    COLOR=0xffe39500
else
    ICON=""
    COLOR=0xffe03600
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
