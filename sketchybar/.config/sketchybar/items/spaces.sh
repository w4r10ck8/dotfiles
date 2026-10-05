#!/bin/bash

# Option+N key codes for native "Switch to Desktop N" (no yabai SA on macOS 27)
KEYCODES=(0 18 19 20 21 23 22 26 28)

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
      click_script="osascript -e 'tell application \"System Events\" to key code ${KEYCODES[$i]} using option down'" \
    --subscribe space."$i" space_change windows_change mouse.clicked
done

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces \
    background.color=$PILL_BG \
    background.border_color=$PILL_BORDER \
    background.border_width=1 \
    background.corner_radius=8 \
    background.height=38 \
    background.drawing=on
