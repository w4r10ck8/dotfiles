#!/bin/bash

sketchybar --add item spotify_art center \
  --set spotify_art \
    padding_left=8 \
    padding_right=2 \
    icon.drawing=off \
    label.drawing=off \
    background.drawing=on \
    background.color=0x00000000 \
    background.height=38 \
    background.corner_radius=4 \
    background.image.drawing=off \
    drawing=off

sketchybar --add item spotify center \
  --set spotify \
    update_freq=5 \
    icon="$SPOTIFY_NOTE" \
    icon.font="SF Pro:Regular:14.0" \
    icon.color=$ICN_BLUE \
    label.color=$TEXT \
    padding_left=2 \
    padding_right=8 \
    drawing=off \
    script="$PLUGIN_DIR/spotify.sh" \
    click_script="osascript -e 'tell application \"Spotify\" to playpause'"
