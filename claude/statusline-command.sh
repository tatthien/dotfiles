#!/bin/sh
# Claude Code status line — three lines:
#   1. model | context used | thinking
#   2. current  <gauge>  N% · <reset time>     (the 5-hour rate-limit window)
#   3. weekly   <gauge>  N% · <reset time>     (the 7-day rate-limit window)
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

# ── vitesse light palette (24-bit true colour) ─────────────────────────────────
reset=$(printf '\033[0m')
bold=$(printf '\033[1m')
fg=$(printf '\033[38;2;57;58;52m')      # fg             #393a34  percentages
gray=$(printf '\033[38;2;153;153;153m') # punctuation    #999999  separators, empty gauge
dim=$(printf '\033[38;2;106;115;125m')  # fg_dim         #6a737d  labels, reset times, thinking
green=$(printf '\033[38;2;30;117;79m')  # keyword        #1e754f  heat: safe
aqua=$(printf '\033[38;2;46;128;143m')  # type           #2e808f  model, filled gauge
yellow=$(printf '\033[38;2;189;164;55m') # regex_escape  #bda437
orange=$(printf '\033[38;2;166;94;43m') # warning        #a65e2b  heat: approaching limit
red=$(printf '\033[38;2;179;29;40m')    # error          #b31d28  heat: near limit

# ── glyphs (raw UTF-8 bytes) ──────────────────────────────────────────────────
g_sep=$(printf '\xe2\x94\x82') # U+2502  box-drawing vertical
g_on=$(printf '\xe2\x97\x8f')  # U+25CF  filled circle — used gauge cell
g_off=$(printf '\xe2\x97\x8b') # U+25CB  empty circle  — free gauge cell
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

# 10-cell gauge: one cell per 10%, filled cells coloured by heat
gauge() { # pct
  n=$((${1} / 10))
  [ "$n" -gt 10 ] && n=10
  [ "$n" -lt 0 ] && n=0
  f='' e='' i=0
  while [ "$i" -lt "$n" ]; do
    f="$f$g_on"
    i=$((i + 1))
  done
  while [ "$i" -lt 10 ]; do
    e="$e$g_off"
    i=$((i + 1))
  done
  printf '%s%s%s%s%s' "$(heat "$1")" "$f" "$gray" "$e" "$reset"
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
# label padded to 7 so both gauges start in the same column
l2=$(printf '%s%-7s%s %s %s%3d%%%s %s%s %s%s' \
  "$dim" current "$reset" "$(gauge "$h5")" \
  "$fg" "$h5" "$reset" "$gray" "$g_dot" "$(when "$h5r")" "$reset")
l3=$(printf '%s%-7s%s %s %s%3d%%%s %s%s %s%s' \
  "$dim" weekly "$reset" "$(gauge "$d7")" \
  "$fg" "$d7" "$reset" "$gray" "$g_dot" "$(when "$d7r")" "$reset")

printf '%s\n%s\n%s\n' "$l1" "$l2" "$l3"
