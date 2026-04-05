#!/bin/bash

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

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

# Generate slug via Claude
PROMPT="Convert this ticket description to a concise kebab-case git branch slug. Max 5 words. Lowercase only. No special characters, slashes, or backticks. Output only the slug, nothing else. Description: $DESCRIPTION"
RAW_SLUG=$(echo "$PROMPT" | claude --print | tr -d '\n')
SLUG=$(echo "$RAW_SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/-\{2,\}/-/g' | sed 's/^-\|-$//g')

echo "$PREFIX/$TICKET_NUMBER/$SLUG"
