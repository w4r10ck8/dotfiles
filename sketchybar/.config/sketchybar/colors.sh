#!/bin/bash

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

# SD_ aliases (used in sketchybarrc)
export SD_BG=$BAR_BG
export SD_FG=$TEXT
export SD_DARK_PURPLE=$PURPLE

# Floating island bar
export ISLAND_BG=0x000e101a
export PILL_BG=0xff161829
export PILL_BORDER=0x59444860

# Icon colors at 60% opacity (icons read too bright at full alpha)
export ICN_FG=0x99ebefc0
export ICN_DIM=0x997a7d6e
export ICN_BLUE=0x9900a3cb
export ICN_GREEN=0x995dcd97
export ICN_YELLOW=0x99e39500
export ICN_RED=0x99e03600
export ICN_INACTIVE=0x99444860

export PLUGIN_DIR="$CONFIG_DIR/plugins"
export ITEM_DIR="$CONFIG_DIR/items"
