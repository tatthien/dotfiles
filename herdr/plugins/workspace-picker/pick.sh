#!/bin/sh
herdr="${HERDR_BIN_PATH:-herdr}"
dir=$(cd "$(dirname "$0")" && pwd)

# Prints "label<TAB>id<TAB>linked<TAB>checkout_path", in Herdr order.
list() {
  "$herdr" workspace list | jq -r '
    .result.workspaces[]
    | "\(.label)\t\(.workspace_id)\t\(.worktree.is_linked_worktree // false)\t\(.worktree.checkout_path // "")"'
}

if [ "$1" = list ]; then
  list
  exit 0
fi

key() { printf '\033[1;38;2;166;173;200m%s\033[0m' "$1"; }
header="$(key enter) focus · $(key ctrl+d) remove worktree"

id=$(list | fzf --delimiter='\t' --with-nth=1 --prompt='workspace > ' \
  --ansi --color='header:#6c7086' --header="$header" \
  --bind "ctrl-d:execute(bash '$dir/confirm-remove.sh' {2} {3} {4})+reload('$dir/pick.sh' list)" |
  cut -f2)

[ -n "$id" ] && "$herdr" workspace focus "$id" >/dev/null
