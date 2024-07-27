set -gx EDITOR nvim

# set -gx TERM screen-256color
set -gx TERM tmux-256color

set -gx VOLTA_HOME $HOME/.volta
set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/adb-fastboot/platform-tools $PATH
set -gx PATH $HOME/.deno/bin $PATH
set -gx PATH $HOME/flutter/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH
set -gx PATH $PATH $HOME/.krew/bin
set -gx PATH $PATH $VOLTA_HOME
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

set -gx ANDROID_SDK_ROOT "$HOME/Library/Android/sdk"
set -gx PATH "$ANDROID_SDK_ROOT/platform-tools" $PATH
set -gx PATH "$ANDROID_SDK_ROOT/emulator" $PATH
set -gx PATH "$HOME/.jenv/bin" $PATH

set -gx LC_ALL en_US.UTF-8

# Disable fish greeting
set -U fish_greeting

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Direnv
direnv hook fish | source

# Starship
starship init fish | source

###### ALIAS ######
alias k='kubectl'
alias m='minikube'
alias s='serverless'

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

# Git
alias gs='git status'
alias gf='git fetch'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gh='git checkout'
alias glo='git log --oneline'
alias gfa='git fetch --all'
alias gsi='git stash --include-untracked'

alias cl='clear'
###### ALIAS ######

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc'; end

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

function gcam
  git commit -am $argv
end
###### FUNCTIONS ######

# pyenv - Python version manager
pyenv init - | source

eval "$(/opt/homebrew/bin/brew shellenv)"

# sst
fish_add_path /Users/thien/.sst/bin

# rbenv - Ruby version manager
status --is-interactive; and rbenv init - fish | source

# jenv - Java version manager
status --is-interactive; and jenv init - | source
