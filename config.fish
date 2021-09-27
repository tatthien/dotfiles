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
alias cfish='nvim ~/dotfiles/config.fish'
alias cnvim='nvim ~/dotfiles/init.vim'
alias calacritty='nvim ~/dotfiles/alacritty/alacritty.yml'
alias ctmux='nvim ~/dotfiles/.tmux.conf'
alias cstarship='nvim ~/dotfiles/starship.toml'

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
