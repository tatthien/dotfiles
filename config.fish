set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/adb-fastboot/platform-tools $PATH
set -gx PATH $HOME/.deno/bin $PATH

set -gx EDITOR nvim

# Terminfo
set -gx TERM xterm-256color-italic

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

# Laravel on Sail
alias sail='bash vendor/bin/sail'

# Beehive
alias b='bash beehive'
alias bs='b docker:start'

# Serverless
alias s='serverless'

# Vim
alias v='nvim'

#----- ALIAS ------

# FUNCTIONS

# ls alternative
function ls
  exa --long --header --git --all --icons $argv
end

# Beehive containers "docker exec" shorthand.
function bxt
  docker exec -it beehive_tenant_apiserver /bin/sh $argv
end

function bxo
  docker exec -it beehive_opc_apiserver /bin/sh $argv
end

function bxd
  docker exec -it beehive_mariadb /bin/sh $argv
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc'; end
