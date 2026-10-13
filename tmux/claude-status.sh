#!/usr/bin/env bash
# Claude Code hook: tags the current tmux pane with @claude_status for tmux-session-manager.sh.
# Usage: claude-status.sh working|waiting|done|idle|clear

[[ -n "$TMUX_PANE" ]] || exit 0

if [[ "$1" == clear ]]; then
  tmux set-option -pu -t "$TMUX_PANE" @claude_status
else
  tmux set-option -p -t "$TMUX_PANE" @claude_status "$1"
fi >/dev/null 2>&1

exit 0
