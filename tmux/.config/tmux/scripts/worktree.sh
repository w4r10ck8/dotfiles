#!/usr/bin/env bash

self="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

git_root=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$git_root" ]; then
  echo "Not in a git repository."
  read -r
  exit 1
fi

repo_name=$(basename "$git_root")

# path of the worktree registered for branch $1 (empty if none)
worktree_path_for_branch() {
  git worktree list --porcelain | awk -v branch="refs/heads/$1" '
    /^worktree / { path=$2 }
    /^branch /   { if ($2 == branch) print path }
  '
}

list_items() {
  local main_path existing plain b path

  main_path=$(git rev-parse --show-toplevel)
  existing=""
  plain=""

  while IFS= read -r b; do
    [ -z "$b" ] && continue
    path=$(worktree_path_for_branch "$b")
    if [ -n "$path" ] && [ "$path" != "$main_path" ]; then
      existing="${existing}✓ ${b}"$'\n'
    else
      plain="${plain}  ${b}"$'\n'
    fi
  done < <(git branch -a --format='%(refname:short)' | sed 's|^origin/||' | sort -u)

  printf '%s%s' "$existing" "$plain"
}

delete_worktree() {
  local line="$1" marker branch path

  marker="${line:0:2}"
  branch="${line:2}"

  if [ "$marker" != "✓ " ]; then
    gum style --foreground 3 "No worktree for '$branch'."
    read -r
    return 0
  fi

  path=$(worktree_path_for_branch "$branch")
  if [ -z "$path" ]; then
    gum style --foreground 3 "Could not find worktree path for '$branch'."
    read -r
    return 0
  fi

  gum confirm "Remove worktree for '$branch'? ($path)" || return 0

  if ! git worktree remove "$path" 2>/tmp/worktree-remove-err; then
    cat /tmp/worktree-remove-err >&2
    rm -f /tmp/worktree-remove-err
    if gum confirm "Uncommitted changes or lock present. Force remove?"; then
      git worktree remove --force "$path"
    else
      return 0
    fi
  fi
  rm -f /tmp/worktree-remove-err

  if [ -n "$TMUX" ]; then
    local idx
    idx=$(tmux list-windows -F '#I:#{window_name}' | awk -F: -v name="$branch" '$2 == name { print $1; exit }')
    [ -n "$idx" ] && tmux kill-window -t "$idx"
  fi

  git worktree prune
}

case "$1" in
  --list)
    list_items
    exit 0
    ;;
  --delete)
    delete_worktree "$2"
    exit 0
    ;;
esac

selection=$("$self" --list | fzf \
  --layout=reverse \
  --header 'enter: open/create · d: delete worktree · esc: cancel' \
  --bind "d:execute(\"$self\" --delete {})+reload(\"$self\" --list)" \
  --prompt "⚡ ")

[ -z "$selection" ] && exit 0

marker="${selection:0:2}"
branch="${selection:2}"

if [ "$marker" = "✓ " ]; then
  path=$(worktree_path_for_branch "$branch")
  if [ -n "$TMUX" ] && tmux list-windows -F '#{window_name}' | grep -qx "$branch"; then
    tmux select-window -t "$branch"
  else
    tmux new-window -c "$path" -n "$branch"
  fi
  exit 0
fi

if ! git check-ref-format --branch "$branch" >/dev/null 2>&1; then
  echo "Invalid branch name: $branch"
  read -r
  exit 1
fi

worktree_dir="${git_root}/../${repo_name}-${branch//\//-}"

if [ ! -d "$worktree_dir" ]; then
  git worktree add "$worktree_dir" "$branch" 2>/dev/null \
    || git worktree add -b "$branch" "$worktree_dir" "HEAD"
fi

tmux new-window -c "$worktree_dir" -n "$branch"
