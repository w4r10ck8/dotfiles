#!/bin/bash

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TICKET_INPUT="$1"

if [ -z "$TICKET_INPUT" ]; then
  exit 1
fi

# Determine prefix from ticket type
if echo "$TICKET_INPUT" | grep -qi "^bug"; then
  PREFIX="bug"
elif echo "$TICKET_INPUT" | grep -qi "^user story"; then
  PREFIX="feat"
elif echo "$TICKET_INPUT" | grep -qi "^release"; then
  PREFIX="release"
else
  PREFIX="feat"
fi

# Extract ticket number (first digit sequence)
TICKET_NUMBER=$(echo "$TICKET_INPUT" | grep -oE '[0-9]+' | head -1)

# Extract description (everything after the first colon)
DESCRIPTION=$(echo "$TICKET_INPUT" | sed 's/^[^:]*:[[:space:]]*//')

PROMPT="Convert this ticket description into 5 distinct kebab-case git branch slugs.

Rules:
- Output exactly 5 lines
- Each line must be a slug only, not the full branch name
- Max 5 words per slug
- Lowercase only
- Use hyphens only
- No numbering, bullets, quotes, explanations, slashes, or backticks

Description: $DESCRIPTION"

RAW_SUGGESTIONS=$(printf '%s' "$PROMPT" | "$SCRIPT_DIR/ai-provider.sh")

if [ -z "$RAW_SUGGESTIONS" ]; then
  exit 1
fi

printf '%s\n' "$RAW_SUGGESTIONS" | while IFS= read -r raw_slug; do
  slug=$(printf '%s' "$raw_slug" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/-\{2,\}/-/g' | sed 's/^-\|-$//g')

  if [ -n "$slug" ]; then
    printf '%s/%s/%s\n' "$PREFIX" "$TICKET_NUMBER" "$slug"
  fi
done | awk '!seen[$0]++' | head -5
