#!/usr/bin/env bash
# Remove task worktrees and local branches whose PR is merged.
# Keeps env-* worktrees, dev/main/master, and any worktree with uncommitted changes.
# Usage: bash cleanup-worktrees.sh <repo dir>   (worktrees live in ../<repo>.worktrees/)
set -u
cd "${1:?usage: cleanup-worktrees.sh <repo dir>}" || exit 1
repo=$(basename "$(git rev-parse --show-toplevel)")
merged=$(gh pr list --state merged --limit 200 --json headRefName -q '.[].headRefName') || { echo "gh failed" >&2; exit 1; }
is_merged() { grep -qxF "$1" <<< "$merged"; }
for d in ../"$repo".worktrees/*/; do
  [ -d "$d" ] || continue
  n=$(basename "$d"); case "$n" in env-*) continue;; esac
  b=$(git -C "$d" branch --show-current 2>/dev/null)
  if [ -n "$b" ] && ! is_merged "$b"; then echo "keep $n ($b not merged)"; continue; fi
  if [ -n "$(git -C "$d" status --porcelain --untracked-files=no 2>/dev/null)" ]; then echo "keep $n (uncommitted changes)"; continue; fi
  git worktree remove --force "$d" && echo "removed $n"
done
git worktree prune
for b in $(git branch --format='%(refname:short)'); do
  case "$b" in dev|main|master) continue;; esac
  is_merged "$b" && git branch -D "$b" >/dev/null 2>&1 && echo "deleted $b"
done
git worktree list
