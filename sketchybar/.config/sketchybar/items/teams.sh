#!/bin/bash

sketchybar --add item teams center \
  --set teams \
    update_freq=10 \
    icon=":microsoft_teams:" \
    icon.font="sketchybar-app-font:Regular:16.0" \
    icon.color=$ICN_DIM \
    label.color=$TEXT \
    label.drawing=off \
    background.drawing=off \
    script="$PLUGIN_DIR/teams.sh" \
    click_script="open -a 'Microsoft Teams'"

sketchybar --add bracket teams_island teams \
  --set teams_island \
    background.color=$PILL_BG \
    background.border_color=$PILL_BORDER \
    background.border_width=1 \
    background.corner_radius=8 \
    background.height=38 \
    background.drawing=on
