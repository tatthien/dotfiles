#!/bin/sh
# Claude Code status line — three lines:
#   1. model | context used | thinking
#   2. current  N% · <reset time>     (the 5-hour rate-limit window)
#   3. weekly   N% · <reset time>     (the 7-day rate-limit window)
#
# Receives the Status hook JSON on stdin. Field names verified against
# Claude Code 2.1.220: .model.display_name, .context_window.used_percentage,
# .rate_limits.{five_hour,seven_day}.{used_percentage,resets_at}, .thinking.enabled.
#
# Glyphs are emitted from their codepoints as raw UTF-8 byte escapes
# (printf '\xNN…') rather than written literally, because literal multibyte
# glyphs get mangled when files in this repo are rewritten. This block is the
# ONLY place glyphs live.

input=$(cat)

# ── one jq pass: emit shell assignments, @sh-quoted so odd branch/dir names are
#    safe to eval. Percentages are floored to integers for POSIX arithmetic. ────
eval "$(printf '%s' "$input" | jq -r '
  @sh "model=\(.model.display_name // "?")
       ctx=\(((.context_window.used_percentage // 0) | floor))
       h5=\(((.rate_limits.five_hour.used_percentage // 0) | floor))
       h5r=\(.rate_limits.five_hour.resets_at // 0)
       d7=\(((.rate_limits.seven_day.used_percentage // 0) | floor))
       d7r=\(.rate_limits.seven_day.resets_at // 0)
       think=\(if .thinking.enabled then "1" else "" end)"
')"

# ── Catppuccin Macchiato palette (24-bit true colour) ──────────────────────────
reset=$(printf '\033[0m')
bold=$(printf '\033[1m')
gray=$(printf '\033[38;2;128;135;162m')  # overlay1  #8087a2  separators, dot
dim=$(printf '\033[38;2;165;173;203m')   # subtext0  #a5adcb  labels, thinking
green=$(printf '\033[38;2;166;218;149m') # green     #a6da95  heat: safe
aqua=$(printf '\033[38;2;139;213;202m')  # teal      #8bd5ca  model
orange=$(printf '\033[38;2;245;169;127m') # peach    #f5a97f  heat: approaching limit
red=$(printf '\033[38;2;237;135;150m')   # red       #ed8796  heat: near limit

# ── glyphs (raw UTF-8 bytes) ──────────────────────────────────────────────────
g_sep=$(printf '\xe2\x94\x82') # U+2502  box-drawing vertical
g_off=$(printf '\xe2\x96\x91') # U+2591  light shade  — thinking marker
g_dot=$(printf '\xc2\xb7')     # U+00B7  middot

# green under half, orange approaching the limit, red near it
heat() { # pct
  if [ "$1" -ge 80 ]; then
    printf '%s' "$red"
  elif [ "$1" -ge 50 ]; then
    printf '%s' "$orange"
  else
    printf '%s' "$green"
  fi
}

# reset time: clock only when it lands today, otherwise "mon d, clock"
when() { # epoch
  [ "${1:-0}" -gt 0 ] 2>/dev/null || {
    printf '%s' '?'
    return
  }
  if [ "$(date -r "$1" +%F)" = "$(date +%F)" ]; then
    date -r "$1" '+%-I:%M%p' | tr 'A-Z' 'a-z'
  else
    date -r "$1" '+%b %-d, %-I:%M%p' | tr 'A-Z' 'a-z'
  fi
}

# ── line 1: model | context | dir (branch*) | thinking ────────────────────────
l1="$bold$aqua$model$reset $gray$g_sep$reset $(heat "$ctx")$ctx%$reset"

[ -n "$think" ] && l1="$l1 $gray$g_sep$reset $dim$g_off thinking$reset"

# ── lines 2+3: the two rate-limit windows ─────────────────────────────────────
# label padded to 7 so both percentages start in the same column
l2=$(printf '%s%-7s%s %s%3d%%%s %s%s %s%s' \
  "$dim" current "$reset" \
  "$(heat "$h5")" "$h5" "$reset" "$gray" "$g_dot" "$(when "$h5r")" "$reset")
l3=$(printf '%s%-7s%s %s%3d%%%s %s%s %s%s' \
  "$dim" weekly "$reset" \
  "$(heat "$d7")" "$d7" "$reset" "$gray" "$g_dot" "$(when "$d7r")" "$reset")

printf '%s\n%s\n%s\n' "$l1" "$l2" "$l3"
