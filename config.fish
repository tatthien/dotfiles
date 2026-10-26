set -gx EDITOR nvim

set -gx PATH $HOME/.deno/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH
set -gx PATH $PATH $HOME/.krew/bin
set -gx PATH $PATH $VOLTA_HOME
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.nvim $PATH
set -gx PATH $HOME/.opencode/bin $PATH
set -gx PATH $HOME/.docker/bin $PATH
set -gx PATH $HOME/Library/Python/3.14/bin $PATH

# set -gx DOCKER_HOST unix://$HOME/.config/colima/default/docker.sock

# go
set -gx GOROOT $HOME/.local/go
set -gx PATH $GOROOT/bin $HOME/go/bin $PATH

if set -q GHOSTTY_RESOURCES_DIR
    source "$GHOSTTY_RESOURCES_DIR"/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end

set -gx LC_ALL en_US.UTF-8

# Claude Code drops to 256 colors inside tmux unless told the terminal passes truecolor through (tmux.conf sets RGB)
set -gx CLAUDE_CODE_TMUX_TRUECOLOR 1

# Disable fish greeting
set -U fish_greeting

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Starship
starship init fish | source

# FNM
fnm env --use-on-cd --shell fish | source

# Direnv
direnv hook fish | source

# fzf (Catppuccin Macchiato, matches tmux)
set -gx FZF_DEFAULT_OPTS "--color=fg:#cad3f5,bg:#24273a,hl:#ed8796,fg+:#cad3f5,bg+:#363a4f,hl+:#ed8796,info:#c6a0f6,border:#6e738d,query:#cad3f5,prompt:#c6a0f6,pointer:#f4dbd6,marker:#b7bdf8,spinner:#f4dbd6,header:#ed8796,gutter:#24273a,separator:#6e738d,scrollbar:#a5adcb,label:#cad3f5,preview-fg:#cad3f5,preview-bg:#1e2030,preview-border:#6e738d"

# Fish syntax highlighting (Catppuccin Latte, matches nvim/ghostty/tmux)
# set -g fish_color_normal 4c4f69
# set -g fish_color_command d20f39
# set -g fish_color_builtin 8839ef
# set -g fish_color_function 8839ef
# set -g fish_color_keyword fe640b
# set -g fish_color_quote 1e66f5
# set -g fish_color_redirection 209fb5
# set -g fish_color_end 6c6f85
# set -g fish_color_error e64553 --bold
# set -g fish_color_param df8e1d
# set -g fish_color_valid_path --underline
# set -g fish_color_option 04a5e5
# set -g fish_color_comment 5c5f77
# set -g fish_color_selection 4c4f69 --background=bcc0cc
# set -g fish_color_operator ea76cb
# set -g fish_color_escape dd7878
# set -g fish_color_autosuggestion 5c5f77
# set -g fish_color_cwd 40a02b --bold
# set -g fish_color_cwd_root e64553 --bold
# set -g fish_color_user 8839ef --bold
# set -g fish_color_host 1e66f5 --bold
# set -g fish_color_host_remote fe640b --bold
# set -g fish_color_status e64553
# set -g fish_color_cancel e64553 --bold
# set -g fish_color_search_match --background=ead3b4
# set -g fish_color_history_current d20f39 --bold
#
# set -g fish_pager_color_progress 6c6f85
# set -g fish_pager_color_prefix d20f39 --bold
# set -g fish_pager_color_completion 4c4f69
# set -g fish_pager_color_description 6c6f85
# set -g fish_pager_color_selected_background --background=bcc0cc
# set -g fish_pager_color_selected_prefix d20f39 --bold
# set -g fish_pager_color_selected_completion 4c4f69
# set -g fish_pager_color_selected_description 4c4f69
# set -g fish_pager_color_secondary_background --background=e6e9ef
# set -g fish_pager_color_secondary_prefix d20f39
# set -g fish_pager_color_secondary_completion 4c4f69
# set -g fish_pager_color_secondary_description 6c6f85

fish_config theme choose catppuccin-macchiato

###### ALIAS ######
alias k='kubectl'
alias m='minikube'
alias s='serverless'

if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# Git
alias gs='git status'
alias gf='git fetch'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gps='git push'
alias gpu='git pull'
alias gch='git checkout'
alias gl='git log'
alias glo='git log --pretty=format:"%C(yellow)%h%Creset %s %C(bold blue)(%an)%Creset"'
alias gfa='git fetch --all'
alias gsi='git stash --include-untracked'
alias gmo='git merge origin/main'

alias lg='lazygit'

alias cl='clear'

alias mypr='gh pr list --author "@me"'

# Agents
alias oc='opencode'

# gcloud
alias gauth='gcloud auth login --brief'

# Worktrunk
alias wl='wt list'
alias wj='wt jira'
alias ws='wt switch'
alias wr='wt remove'

# Tmux
alias ta='tmux attach -t'

# Herdr
alias h='herdr'

###### ALIAS ######

###### FUNCTIONS ######
function vim --wraps=nvim --description 'alias vim=nvim'
    nvim $argv
end

function cat --wraps=bat --description 'alias cat=bat'
    bat $argv
end

###### FUNCTIONS ######
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien.nguyen/Downloads/google-cloud-sdk/path.fish.inc' ]
    . '/Users/thien.nguyen/Downloads/google-cloud-sdk/path.fish.inc'
end
