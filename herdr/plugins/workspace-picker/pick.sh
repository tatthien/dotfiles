#!/bin/sh
herdr="${HERDR_BIN_PATH:-herdr}"
dir=$(cd "$(dirname "$0")" && pwd)

# Prints "label<TAB>id<TAB>linked<TAB>checkout_path", sorted by label.
# A linked worktree's label gets its parent workspace's label as a prefix.
list() {
  "$herdr" workspace list | jq -r '
    .result.workspaces as $all
    | $all[]
    | (.worktree // {}) as $wt
    | ([$all[] | select(.worktree.repo_key == $wt.repo_key and (.worktree.is_linked_worktree | not))][0].label // $wt.repo_name) as $parent
    | (if $wt.is_linked_worktree and (.label | startswith($parent) | not)
        then $parent + "-" + .label
        else .label end) as $name
    | "\($name)\t\(.workspace_id)\t\(.worktree.is_linked_worktree // false)\t\(.worktree.checkout_path // "")"' |
    LC_ALL=C sort -f -t "$(printf '\t')" -k1,1
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
