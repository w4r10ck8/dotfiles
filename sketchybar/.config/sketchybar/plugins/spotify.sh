#!/bin/bash

if ! osascript -e 'application "Spotify" is running' 2>/dev/null | grep -q "true"; then
  sketchybar --set spotify_art drawing=off
  sketchybar --set spotify drawing=off
  exit 0
fi

STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)

if [ "$STATE" != "playing" ]; then
  sketchybar --set spotify_art drawing=off
  sketchybar --set spotify drawing=off
  exit 0
fi

ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
LABEL="$TRACK — $ARTIST"

if [ ${#LABEL} -gt 40 ]; then
  LABEL="${LABEL:0:37}..."
fi

# Fetch artwork (cache by track name to avoid re-downloading every 5s)
ART_CACHE="/tmp/spotify_art_track"
ART_RAW="/tmp/spotify_art_raw.jpg"
ART_THUMB="/tmp/spotify_art_thumb.jpg"
CURRENT_TRACK="$ARTIST:$TRACK"

if [ ! -f "$ART_CACHE" ] || [ "$(cat "$ART_CACHE" 2>/dev/null)" != "$CURRENT_TRACK" ]; then
  ART_URL=$(osascript -e 'tell application "Spotify" to artwork url of current track as string' 2>/dev/null)
  if [ -n "$ART_URL" ]; then
    curl -s "$ART_URL" -o "$ART_RAW"
    # Resize to exactly 28x28 so sketchybar renders it at the right size
    sips -z 28 28 "$ART_RAW" --out "$ART_THUMB" &>/dev/null
    echo "$CURRENT_TRACK" > "$ART_CACHE"
  fi
fi

if [ -f "$ART_THUMB" ]; then
  sketchybar --set spotify_art \
    drawing=on \
    background.image="$ART_THUMB" \
    background.image.drawing=on \
    background.image.scale=1.0 \
    background.drawing=on
else
  sketchybar --set spotify_art drawing=off
fi

sketchybar --set spotify drawing=on label="$LABEL"
