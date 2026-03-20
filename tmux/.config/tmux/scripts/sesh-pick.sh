#!/usr/bin/env bash

selected=$(sesh list -i | gum filter \
  --no-strip-ansi \
  --limit 1 \
  --no-sort \
  --fuzzy \
  --placeholder 'Pick a sesh' \
  --height 50 \
  --prompt '⚡ ')

[ -z "$selected" ] && exit 0

sesh connect "$selected"
