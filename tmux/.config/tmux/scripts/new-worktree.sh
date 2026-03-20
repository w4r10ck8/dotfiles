#!/usr/bin/env bash

git_root=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$git_root" ]; then
  echo "Not in a git repository."
  read -r
  exit 1
fi

repo_name=$(basename "$git_root")

branch=$(git branch -a --format='%(refname:short)' | sed 's|origin/||' | sort -u | gum filter \
  --placeholder "Select branch for worktree..." \
  --height 20 \
  --prompt "⚡ ")

[ -z "$branch" ] && exit 0

worktree_dir="${git_root}/../${repo_name}-${branch//\//-}"

if [ ! -d "$worktree_dir" ]; then
  git worktree add "$worktree_dir" "$branch" 2>/dev/null \
    || git worktree add -b "$branch" "$worktree_dir" "HEAD"
fi

tmux new-window -c "$worktree_dir" -n "$branch"
