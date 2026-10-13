#!/usr/bin/env bash

self="$0"

# Prints "<claude status icon>\t<session>", skipping auto-generated "claude <id>" sessions.
# Status comes from the @claude_status pane option set by tmux/claude-status.sh.
list_sessions() {
  tmux list-panes -a -F "#{session_name}	#{@claude_status}" 2>/dev/null |
    awk -F'\t' '
      BEGIN {
        rank["idle"] = 1; rank["done"] = 2; rank["working"] = 3; rank["waiting"] = 4
        icon[""] = " "
        icon["idle"] = "\033[90m○\033[0m"
        icon["done"] = "\033[32m✓\033[0m"
        icon["working"] = "\033[33m◐\033[0m"
        icon["waiting"] = "\033[31m●\033[0m"
      }
      $1 ~ /^claude / { next }
      !($1 in best) { order[++n] = $1; best[$1] = "" }
      rank[$2] > rank[best[$1]] { best[$1] = $2 }
      END { for (i = 1; i <= n; i++) printf "%s\t%s\n", icon[best[order[i]]], order[i] }
    '
}

if [[ "$1" == list ]]; then
  list_sessions
  exit 0
fi

legend=$'\033[31m●\033[0m waiting  \033[33m◐\033[0m working  \033[32m✓\033[0m done  \033[90m○\033[0m idle'

selected=$(list_sessions | fzf \
  --ansi \
  --delimiter='\t' \
  --tabstop=2 \
  --nth=2 \
  --accept-nth=2 \
  --prompt="session > " \
  --header=$'Enter: switch   Ctrl+a: new   Ctrl+d: delete   Ctrl+r: refresh\n'"$legend" \
  --bind "ctrl-d:execute(tmux kill-session -t {2})+reload('$self' list)" \
  --bind "ctrl-a:execute(tmux new-session -d -s {q})+reload('$self' list)" \
  --bind "ctrl-r:reload('$self' list)" \
  --preview="tmux capture-pane -ep -t {2}" \
  --preview-window='right,62%,nowrap' \
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
