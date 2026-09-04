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

# fzf (GitHub Light, matches nvim/ghostty/tmux)
set -gx FZF_DEFAULT_OPTS "--color=fg:#1f2328,bg:#ffffff,hl:#0550ae,fg+:#1f2328,bg+:#e7eaf0,hl+:#cf222e,info:#57606a,border:#d0d7de,query:#1f2328,prompt:#cf222e,pointer:#6639ba,marker:#9a6700,spinner:#0550ae,header:#57606a,gutter:#ffffff,separator:#d0d7de,scrollbar:#6e7781,label:#6e7781,preview-fg:#1f2328,preview-bg:#f6f8fa,preview-border:#d0d7de"

# Fish syntax highlighting (GitHub Light, matches nvim/ghostty/tmux)
set -g fish_color_normal 1f2328
set -g fish_color_command cf222e
set -g fish_color_builtin 6639ba
set -g fish_color_function 6639ba
set -g fish_color_keyword 953800
set -g fish_color_quote 0a3069
set -g fish_color_redirection 0550ae
set -g fish_color_end 6e7781
set -g fish_color_error d1242f --bold
set -g fish_color_param 9a6700
set -g fish_color_valid_path --underline
set -g fish_color_option 0969da
set -g fish_color_comment 57606a
set -g fish_color_selection 1f2328 --background=dae9f9
set -g fish_color_operator 8250df
set -g fish_color_escape 633c01
set -g fish_color_autosuggestion 57606a
set -g fish_color_cwd 1a7f37 --bold
set -g fish_color_cwd_root d1242f --bold
set -g fish_color_user 6639ba --bold
set -g fish_color_host 0550ae --bold
set -g fish_color_host_remote bc4c00 --bold
set -g fish_color_status d1242f
set -g fish_color_cancel d1242f --bold
set -g fish_color_search_match --background=e1d1b3
set -g fish_color_history_current cf222e --bold

set -g fish_pager_color_progress 6e7781
set -g fish_pager_color_prefix cf222e --bold
set -g fish_pager_color_completion 1f2328
set -g fish_pager_color_description 6e7781
set -g fish_pager_color_selected_background --background=dae9f9
set -g fish_pager_color_selected_prefix cf222e --bold
set -g fish_pager_color_selected_completion 1f2328
set -g fish_pager_color_selected_description 1f2328
set -g fish_pager_color_secondary_background --background=f6f8fa
set -g fish_pager_color_secondary_prefix cf222e
set -g fish_pager_color_secondary_completion 1f2328
set -g fish_pager_color_secondary_description 6e7781

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
alias glo='git log --oneline'
alias gfa='git fetch --all'
alias gsi='git stash --include-untracked'
alias lg='lazygit'

alias cl='clear'

alias mypr='gh pr list --author "@me"'

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
