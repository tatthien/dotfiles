set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/adb-fastboot/platform-tools $PATH
set -gx PATH $HOME/.deno/bin $PATH
set -gx PATH $HOME/flutter/bin $PATH

set -gx EDITOR nvim

# Disable fish greeting
set -U fish_greeting

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Direnv
direnv hook fish | source

# Starship
starship init fish | source

#----- ALIAS ------

# Kubernetes
alias k='kubectl'
alias m='minikube'

# Serverless
alias s='serverless'

# Vim
alias vim='nvim'

# Docker
alias dc='docker-compose'

alias gs='git status'
alias gh='git checkout'
alias gc='git commit'
alias ga='git add'
#----- ALIAS ------


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc'; end
