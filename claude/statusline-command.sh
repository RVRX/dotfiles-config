#!/usr/bin/env bash
# Claude Code status line:
#   ~/path (git-branch) | model | context%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_cwd="${cwd/#$home/~}"

prompt="${short_cwd}"

# Git branch and status (skip optional locks so we don't block)
if git_dir=$(git -C "$cwd" rev-parse --git-dir 2>/dev/null); then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Gather status indicators
    git_flags=""
    # Modified files
    if ! git -C "$cwd" diff --quiet 2>/dev/null; then
      git_flags="${git_flags}*"
    fi
    # Staged files
    if ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
      git_flags="${git_flags}+"
    fi
    # Untracked files
    if [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | head -1)" ]; then
      git_flags="${git_flags}%"
    fi
    # Stash
    if git -C "$cwd" rev-parse --verify refs/stash >/dev/null 2>&1; then
      git_flags="${git_flags}\$"
    fi
    prompt="${prompt} (${branch}${git_flags})"
  fi
fi

# Model
if [ -n "$model" ]; then
  prompt="${prompt} | ${model}"
fi

# Context remaining
if [ -n "$remaining" ]; then
  printf_remaining=$(printf "%.0f" "$remaining")
  prompt="${prompt} | ctx:${printf_remaining}% left"
fi

printf '%s' "$prompt"
