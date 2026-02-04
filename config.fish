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

set -gx LC_ALL en_US.UTF-8

# Disable fish greeting
set -U fish_greeting

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Starship
starship init fish | source

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
alias gh='git checkout'
alias gl='git log'
alias glo='git log --oneline'
alias gfa='git fetch --all'
alias gsi='git stash --include-untracked'
alias lg='lazygit'

alias cl='clear'
###### ALIAS ######

###### FUNCTIONS ######
function qq
    clear

    set logpath "$TMPDIR/q"
    if test -z "$TMPDIR"
        set logpath "/tmp/q"
    end

    if test ! -f "$logpath"
        echo 'Q LOG' > "$logpath"
    end

    tail -100f -- "$logpath"
end

function rmqq
    set logpath "$TMPDIR/q"
    if test -z "$TMPDIR"
        set logpath "/tmp/q"
    end
    if test -f "$logpath"
        rm "$logpath"
    end
    qq
end

function vim --wraps=nvim --description 'alias vim=nvim'
  nvim $argv
end

function cat --wraps=bat --description 'alias cat=bat'
  bat $argv
end

###### FUNCTIONS ######

eval "$(/opt/homebrew/bin/brew shellenv)"

# sst
fish_add_path /Users/thien/.sst/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
