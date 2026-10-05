#!/bin/bash

# Force a palette: Light, Dark, or empty to follow macOS appearance
FORCE_THEME=Light
THEME=${FORCE_THEME:-$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)}

if [ "$THEME" = "Dark" ]; then
  # Duckbones colorscheme
  export BAR_BG=0xff0e101a
  export WS_ACTIVE_BG=0xff00a3cb
  export WS_ACTIVE_FG=0xff0e101a
  export WS_INACTIVE_BG=0xff161829
  export WS_INACTIVE_FG=0xff444860
  export TEXT=0xffebefc0
  export TEXT_DIM=0xff7a7d6e
  export BLUE=0xff00a3cb
  export GREEN=0xff5dcd97
  export YELLOW=0xffe39500
  export RED=0xffe03600
  export PURPLE=0xff795ccc
  export SHADOW=0x60000000
else
  # Light palette (follows macOS appearance)
  export BAR_BG=0xfff4f1e8
  export WS_ACTIVE_BG=0xff0077a0
  export WS_ACTIVE_FG=0xfff4f1e8
  export WS_INACTIVE_BG=0xffe6e2d6
  export WS_INACTIVE_FG=0xff9a9686
  export TEXT=0xff1f2130
  export TEXT_DIM=0xff6b6a5e
  export BLUE=0xff0077a0
  export GREEN=0xff2e8b5f
  export YELLOW=0xffb87400
  export RED=0xffc02e00
  export PURPLE=0xff6244b0
  export SHADOW=0x00000000
fi

# SD_ aliases (used in sketchybarrc)
export SD_BG=$BAR_BG
export SD_FG=$TEXT
export SD_DARK_PURPLE=$PURPLE

# Floating island bar
export ISLAND_BG=0x00000000
export PILL_BG=$WS_INACTIVE_BG
export PILL_BORDER=0x59${WS_INACTIVE_FG:4}

# Icon colors at 60% opacity (icons read too bright at full alpha)
export ICN_FG=0x99${TEXT:4}
export ICN_DIM=0x99${TEXT_DIM:4}
export ICN_BLUE=0x99${BLUE:4}
export ICN_GREEN=0x99${GREEN:4}
export ICN_YELLOW=0x99${YELLOW:4}
export ICN_RED=0x99${RED:4}
export ICN_INACTIVE=0x99${WS_INACTIVE_FG:4}

export PLUGIN_DIR="$CONFIG_DIR/plugins"
export ITEM_DIR="$CONFIG_DIR/items"
