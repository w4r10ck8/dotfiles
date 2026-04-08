#!/bin/bash

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

prompt=$(cat)

if [ -z "$prompt" ]; then
  echo "No prompt provided." >&2
  exit 1
fi

run_claude() {
  if ! command -v claude >/dev/null 2>&1; then
    return 1
  fi

  local output
  output=$(printf '%s' "$prompt" | claude --print 2>/dev/null)
  local status=$?

  if [ $status -ne 0 ] || [ -z "$output" ]; then
    return 1
  fi

  printf '%s' "$output"
}

run_codex() {
  if ! command -v codex >/dev/null 2>&1; then
    return 1
  fi

  local output_file
  output_file=$(mktemp "${TMPDIR:-/tmp}/codex-last.XXXXXX")

  if ! printf '%s' "$prompt" | codex exec --skip-git-repo-check --sandbox read-only -C "$PWD" -o "$output_file" - >/dev/null 2>&1; then
    rm -f "$output_file"
    return 1
  fi

  local output
  output=$(cat "$output_file" 2>/dev/null)
  rm -f "$output_file"

  if [ -z "$output" ]; then
    return 1
  fi

  printf '%s' "$output"
}

if output=$(run_claude); then
  printf '%s' "$output"
  exit 0
fi

if output=$(run_codex); then
  printf '%s' "$output"
  exit 0
fi

echo "AI generation failed with both Claude and Codex." >&2
exit 1
