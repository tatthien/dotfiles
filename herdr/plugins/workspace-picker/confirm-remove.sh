#!/bin/bash
herdr="${HERDR_BIN_PATH:-herdr}"
id=$1 linked=$2 path=$3

# Colors copied from the Herdr confirm popup (catppuccin macchiato).
reset=$'\033[0m'
bg=$'\033[48;2;24;24;37m'
red=$'\033[38;2;237;135;150m'
text=$'\033[38;2;202;211;245m'
dim=$'\033[38;2;147;154;183m'
bold=$'\033[1m'
btn_red=$'\033[1;48;2;237;135;150;38;2;24;24;37m'
btn_gray=$'\033[1;48;2;54;58;79;38;2;202;211;245m'

read -r rows cols < <(stty size 2>/dev/null)
rows=${rows:-24} cols=${cols:-80}
trap 'printf "%s\033[?25h" "$reset"' EXIT

# at ROW STYLE TEXT: prints TEXT at column 2, clipped to the popup, then restores the background.
at() { printf '\033[%d;2H%s%s%s%s' "$1" "$2" "${3:0:$((cols - 2))}" "$reset" "$bg"; }

# dialog TITLE BUTTONS LINE... (a LINE starting with "~" is dimmed)
dialog() {
  local title=$1 buttons=$2 i=2 line style
  shift 2
  printf '\033[?25l%s\033[2J' "$bg"
  at 1 "$red$bold" "$title"
  for line in "$@"; do
    style=$text
    [[ $line == '~'* ]] && style=$dim line=${line#\~}
    at "$i" "$style" "$line"
    ((i++))
  done
  printf '\033[%d;2H%s%s%s' "$((i + 1))" "$buttons" "$reset" "$bg"
}

# Returns 0 on Enter, 1 on Esc.
confirm() {
  local key
  while IFS= read -rsn1 key; do
    [[ -z $key ]] && return 0
    [[ $key == $'\e' ]] && return 1
  done
  return 1
}

pad() { printf '%*s' "$1" ''; }
btn_remove="$btn_red$(pad 7)↲ remove$(pad 7)$reset$bg"
btn_cancel="$btn_gray$(pad 2)esc cancel$(pad 2)$reset$bg"
btn_close="$btn_gray$(pad 2)esc close$(pad 2)$reset$bg"

if [[ $linked != true || -z $path ]]; then
  dialog "cannot delete worktree" "$btn_close" \
    "Only a linked worktree checkout can be deleted." \
    "This workspace is not one."
  confirm
  exit 0
fi

dialog "delete worktree checkout?" "$btn_remove  $btn_cancel" \
  "This removes the checkout folder:" \
  "~$path" \
  "The branch is not deleted. The Herdr workspace will close."

confirm || exit 0

if ! out=$("$herdr" worktree remove --workspace "$id" 2>&1); then
  dialog "delete worktree failed" "$btn_close" "$out"
  confirm
fi
