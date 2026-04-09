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

alias nvmuse='nvm install latest && nvm use'
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
