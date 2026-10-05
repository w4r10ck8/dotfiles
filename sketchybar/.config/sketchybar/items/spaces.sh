#!/bin/bash

for i in $(seq 1 8); do
  sketchybar --add item space."$i" left \
    --set space."$i" \
      icon="$i" \
      icon.padding_left=10 \
      icon.padding_right=6 \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.padding_right=16 \
      label.drawing=off \
      background.drawing=off \
      script="$PLUGIN_DIR/space.sh" \
      click_script="aerospace workspace $i" \
    --subscribe space."$i" aerospace_workspace_change mouse.clicked
done

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces \
    background.color=$PILL_BG \
    background.border_color=$PILL_BORDER \
    background.border_width=1 \
    background.corner_radius=8 \
    background.height=38 \
    background.drawing=on
