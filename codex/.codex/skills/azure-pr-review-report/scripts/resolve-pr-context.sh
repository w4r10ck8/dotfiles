#!/bin/bash

set -euo pipefail

pr_number="${1:-}"

if [[ -z "$pr_number" ]]; then
  echo "Usage: $0 <pr-number>" >&2
  exit 1
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

repo_name="$(basename "$repo_root")"
report_path="$repo_root/.reviews/PR-${pr_number}-review.md"
current_branch="$(git rev-parse --abbrev-ref HEAD)"
origin_url="$(git remote get-url origin 2>/dev/null || true)"
mode="local"
title="Unknown"
source_branch="$current_branch"
target_branch=""

trim_ref() {
  local ref="$1"
  printf '%s' "${ref#refs/heads/}"
}

resolve_default_target_branch() {
  local candidate=""

  candidate="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##' || true)"
  if [[ -n "$candidate" ]]; then
    printf '%s' "$candidate"
    return 0
  fi

  for branch in main master develop; do
    if git show-ref --verify --quiet "refs/heads/$branch" || git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      printf '%s' "$branch"
      return 0
    fi
  done

  return 1
}

has_ref() {
  local ref="$1"
  git rev-parse --verify --quiet "$ref" >/dev/null 2>&1
}

choose_git_ref() {
  local branch="$1"

  if [[ "$current_branch" == "$branch" ]]; then
    printf '%s' "HEAD"
    return 0
  fi

  if has_ref "refs/heads/$branch"; then
    printf '%s' "$branch"
    return 0
  fi

  if has_ref "refs/remotes/origin/$branch"; then
    printf '%s' "origin/$branch"
    return 0
  fi

  return 1
}

ensure_remote_ref() {
  local branch="$1"

  if has_ref "refs/heads/$branch" || has_ref "refs/remotes/origin/$branch"; then
    return 0
  fi

  if [[ -n "$origin_url" ]]; then
    git fetch origin "$branch" --quiet >/dev/null 2>&1 || true
  fi
}

if command -v az >/dev/null 2>&1; then
  az_output="$(AZURE_CORE_COLLECT_TELEMETRY=no az repos pr show --id "$pr_number" --query '[title,sourceRefName,targetRefName]' -o tsv 2>/dev/null || true)"

  if [[ -n "$az_output" ]]; then
    mode="azure"
    IFS=$'\t' read -r title source_ref target_ref <<<"$az_output"
    source_branch="$(trim_ref "$source_ref")"
    target_branch="$(trim_ref "$target_ref")"
  fi
fi

if [[ -z "$target_branch" ]]; then
  target_branch="$(resolve_default_target_branch || true)"
fi

if [[ -z "$target_branch" ]]; then
  echo "Could not determine the target branch." >&2
  exit 1
fi

ensure_remote_ref "$source_branch"
ensure_remote_ref "$target_branch"

source_git_ref="$(choose_git_ref "$source_branch" || true)"
target_git_ref="$(choose_git_ref "$target_branch" || true)"

if [[ -z "$source_git_ref" ]]; then
  source_git_ref="HEAD"
fi

if [[ -z "$target_git_ref" ]]; then
  echo "Could not resolve a local git ref for target branch '$target_branch'." >&2
  exit 1
fi

changed_files="$(git diff --name-only "${target_git_ref}...${source_git_ref}" || true)"

cat <<EOF
mode: $mode
pr_number: $pr_number
title: $title
repo_root: $repo_root
repo_name: $repo_name
report_path: $report_path
source_branch: $source_branch
target_branch: $target_branch
source_git_ref: $source_git_ref
target_git_ref: $target_git_ref
changed_files:
EOF

if [[ -n "$changed_files" ]]; then
  while IFS= read -r file; do
    [[ -n "$file" ]] && printf -- '- %s\n' "$file"
  done <<<"$changed_files"
fi
