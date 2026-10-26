#!/bin/sh
herdr="${HERDR_BIN_PATH:-herdr}"

id=$("$herdr" workspace list \
  | jq -r '.result.workspaces[] | "\(.label)\t\(.workspace_id)"' \
  | fzf --delimiter='\t' --with-nth=1 --reverse --prompt='workspace> ' \
  | cut -f2)

[ -n "$id" ] && "$herdr" workspace focus "$id" >/dev/null
