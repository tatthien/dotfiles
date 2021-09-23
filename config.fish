set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/adb-fastboot/platform-tools $PATH
set -gx PATH $HOME/.deno/bin $PATH

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Starship
starship init fish | source

#----- ALIAS ------
# Edit dotfiles
alias cfish='nvim ~/.config/fish/config.fish'
alias cnvim='nvim ~/.config/nvim/init.vim'
alias calacritty='nvim ~/.config/alacritty/alacritty.yml'
alias ctmux='nvim ~/.tmux.conf'
alias cstarship='nvim ~/.config/starship.toml'

# Kubernetes
alias k='kubectl'
alias m='minikube'

# Laravel on Sail
alias sail='bash vendor/bin/sail'

# Beehive
alias b='bash beehive'
alias bs='b docker:start'
alias bxt='b docker:exec:tenant'
alias bxo='b docker:exec:opc'

alias ls='exa --long --header --git --all --icons'

# Serverless
alias s='serverless'

# Vim
alias v='nvim'

#----- ALIAS ------

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/google-cloud-sdk/path.fish.inc'; end
