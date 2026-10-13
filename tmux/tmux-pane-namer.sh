#!/usr/bin/env bash
# Titles every pane of the given tmux session after what it is doing, via crush (Copilot, as in the worktrunk jira alias).
# Usage: tmux-pane-namer.sh <session-id>   (bound to prefix + N; run in the background by run-shell -b)
# A pane keeps its title when crush fails or gives nothing usable for it.

# tmux.conf sets a PATH without ~/.local/bin, where crush lives.
export PATH="$HOME/.local/bin:$PATH"

sid="${1:-$(tmux display-message -p '#{session_id}')}"
LINES_PER_PANE=40
MAX_LEN=30

say() { tmux display-message -d 3000 "pane namer: $*"; }

panes=$(tmux list-panes -s -t "$sid" -F '#{pane_id}') || exit 1

content=""
while IFS=$'\t' read -r pane cmd path; do
  text=$(tmux capture-pane -p -J -t "$pane" -S "-$LINES_PER_PANE" | sed '/^[[:space:]]*$/d')
  content+=$'\n'"### $pane: $cmd in $path"$'\n'"$text"$'\n'
done < <(tmux list-panes -s -t "$sid" -F $'#{pane_id}\t#{pane_current_command}\t#{pane_current_path}')

say "naming $(printf '%s\n' "$panes" | wc -l | tr -d ' ') panes…"

raw=$(printf '%s' "$content" | crush run --quiet "Above is the visible content of each pane in one tmux session; each pane starts with a line '### <pane id>: <command> in <folder>'. Give EACH pane a short, generic title (max $MAX_LEN chars) naming the tool or role, not the details of the work:
- an editor: its name, e.g. 'nvim' for Neovim
- a coding agent or AI CLI: its tool name, e.g. 'claude' for Claude Code, 'opencode', 'codex', 'crush'
- a long-running dev server or watcher: 'dev', or 'dev:<part>' when the script or output names a part, e.g. 'dev:client' for 'pnpm dev:client', 'dev:admin', 'dev:storybook'
- anything else: a short generic role, e.g. 'shell', 'git', 'tests', 'logs'
For each pane output exactly one line: the pane id, then ' | ', then the title. Output ONLY those lines — no explanation, no markdown, no quotes.") \
  || { say "crush failed; kept the titles"; exit 1; }

renamed=0
while IFS= read -r line; do
  # '%12 | some title', tolerating stray markdown or ANSI around it
  line=$(printf '%s' "$line" | sed $'s/\x1b\\[[0-9;]*[A-Za-z]//g')
  pane=$(printf '%s' "$line" | sed -nE 's/^[^%]*(%[0-9]+)[^|]*\|.*$/\1/p')
  title=$(printf '%s' "$line" | sed -E 's/^[^|]*\|//' | tr -d '`*"\r' | tr -s '[:space:]' ' ' | sed -E "s/^[ ']+//; s/[ ']+$//" | cut -c1-"$MAX_LEN" | sed -E 's/ +$//')
  [ -n "$pane" ] && [ -n "$title" ] || continue
  printf '%s\n' "$panes" | grep -qx -- "$pane" || continue
  tmux select-pane -t "$pane" -T "$title" && renamed=$((renamed + 1))
done <<< "$raw"

if [ "$renamed" -eq 0 ]; then
  say "no usable titles from crush; kept the titles"
  exit 1
fi
say "titled $renamed pane(s)"
