#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo '\d+%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c 'AC Power')

if [ "$CHARGING" -gt 0 ]; then
    ICON=$BATTERY_CHARGING
    COLOR=$ICN_GREEN
elif [ "$PERCENTAGE" -ge 50 ]; then
    ICON=$BATTERY_100
    COLOR=$ICN_GREEN
elif [ "$PERCENTAGE" -ge 20 ]; then
    ICON=$BATTERY_50
    COLOR=$ICN_YELLOW
else
    ICON=$BATTERY_25
    COLOR=$ICN_RED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
