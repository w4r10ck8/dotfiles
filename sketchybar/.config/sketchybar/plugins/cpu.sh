#!/bin/bash

source "$CONFIG_DIR/colors.sh"

USAGE=$(top -l 1 -n 0 | awk -F'[:,]' '/CPU usage/ {idle=$4; gsub(/[^0-9.]/,"",idle); printf "%d", 100-idle}')

COLOR=$ICN_GREEN
[ "$USAGE" -ge 50 ] && COLOR=$ICN_YELLOW
[ "$USAGE" -ge 80 ] && COLOR=$ICN_RED

sketchybar --set "$NAME" icon.color="$COLOR" label="${USAGE}%"
