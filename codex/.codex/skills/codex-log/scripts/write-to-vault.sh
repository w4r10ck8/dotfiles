#!/usr/bin/env bash
# write-to-vault.sh — Create a Codex vault note and log to today's daily note.
#
# Usage:
#   write-to-vault.sh "<relative-note-path>" "<full note markdown>" "<daily summary>"
#
# Example:
#   write-to-vault.sh \
#     "02-projects/Fair Work Commission/tickets/FWC-1234 - Fix form validation.md" \
#     "$(cat /tmp/note-content.md)" \
#     "Fixed null pointer in form validation"

set -euo pipefail

NOTE_PATH="${1:?Missing note path}"
CONTENT="${2:?Missing note content}"
DAILY_SUMMARY="${3:?Missing daily summary}"

NOTE_TITLE="$(basename "$NOTE_PATH" .md)"
TODAY="$(date '+%d %b %Y - %A')"

# Create or overwrite the note
obsidian-cli create --vault Codex --content "$CONTENT" "$NOTE_PATH"

# Ensure today's daily note exists
obsidian-cli daily --vault Codex 2>/dev/null || true

# Append to ## Today's Work
obsidian-cli create --vault Codex --append \
  --content "- [[$NOTE_TITLE]] - $DAILY_SUMMARY" \
  "$TODAY"

echo "Logged: $NOTE_TITLE"
echo "Daily note updated: $TODAY"
