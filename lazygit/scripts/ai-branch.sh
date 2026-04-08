#!/bin/bash

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"

BRANCH_NAME="$1"

if [ -z "$BRANCH_NAME" ]; then
  echo "No branch name selected."
  exit 1
fi

if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  git checkout "$BRANCH_NAME" 2>&1
else
  git checkout -b "$BRANCH_NAME" 2>&1
fi

echo ""
echo "Checked out: $BRANCH_NAME"
