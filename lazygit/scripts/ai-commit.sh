#!/bin/bash
# ai-commit.sh
# Generates a commit message from staged changes using Claude AI.
# Used as a lazygit custom command — outputs the message to stdout
# so lazygit can pre-fill the commit prompt.

DIFF=$(git diff --cached)

if [ -z "$DIFF" ]; then
  echo "No staged changes found." >&2
  exit 1
fi

PROMPT="You are an expert developer writing git commit messages.
Analyse the following git diff and generate a single commit message.

Rules:
- Use conventional commits format: <type>(<scope>): <description>
- Types: feat, fix, refactor, style, docs, test, chore
- First line max 72 characters
- Imperative mood (e.g. 'add', not 'added' or 'adds')
- Output ONLY the raw commit message text, no backticks, no markdown, no code blocks, no quotes

Diff:
$DIFF"

echo "$PROMPT" | claude --print | tr -d '\n'
