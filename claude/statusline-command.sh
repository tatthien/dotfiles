#!/bin/sh
# Claude Code status line — model, context usage, git branch
# Receives JSON via stdin

input=$(cat)

# --- Extract fields ---
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')

# --- Git branch (empty when not in a repo) ---
branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ "$branch" = "HEAD" ]; then
  branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null) # detached: show short sha
fi

# --- Gruvbox colours (24-bit true colour) ---
reset='\033[0m'
bold='\033[1m'
dim='\033[2m'
italic='\033[3m'
bright_white='\033[38;2;168;153;132m' # gray    #a89984
bright_green='\033[38;2;184;187;38m'  # green   #b8bb26
bright_cyan='\033[38;2;142;192;124m'  # aqua    #8ec07c
bright_yellow='\033[38;2;250;189;47m' # yellow  #fabd2f
bright_red='\033[38;2;251;73;52m'     # red     #fb4934
bright_orange='\033[38;2;254;128;25m' # orange  #fe8019

# --- Context usage label ---
if [ "$(echo "$ctx_pct >= 80" | bc 2>/dev/null)" = "1" ]; then
  ctx_color="${bright_red}"
  ctx_label="[HIGH]"
elif [ "$(echo "$ctx_pct >= 50" | bc 2>/dev/null)" = "1" ]; then
  ctx_color="${bright_orange}"
  ctx_label="[MED]"
else
  ctx_color="${bright_green}"
  ctx_label="[LOW]"
fi

ctx_pct_fmt=$(printf "%.1f" "$ctx_pct")

# --- Build line ---
line="${bold}${bright_white}${model}${reset}"
line="${line}  ${ctx_color}${ctx_pct_fmt}% ${ctx_label}${reset}"
if [ -n "$branch" ]; then
  line="${line}  ${dim}${reset} ${bright_green}${branch}${reset}"
fi

# --- Output ---
printf "%b\n" "${line}"
