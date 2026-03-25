#!/usr/bin/env bash

# Fetch current tmux sessions
sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

# Run fzf with custom bindings to match your screenshot
selected=$(echo "$sessions" | fzf \
  --prompt="session > " \
  --header="Enter: switch   Ctrl+n: new   Ctrl+d: delete" \
  --bind "ctrl-d:execute(tmux kill-session -t {})+reload(tmux list-sessions -F '#{session_name}')" \
  --bind "ctrl-n:execute(tmux new-session -d -s {q})+reload(tmux list-sessions -F '#{session_name}')" \
  --height=100% \
  --info=default)

# If a session was selected (via Enter), switch to it
if [[ -n "$selected" ]]; then
  # If we are already inside a tmux session, switch the client
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$selected"
  else
    # If run from outside tmux, attach to it
    tmux attach-session -t "$selected"
  fi
fi
