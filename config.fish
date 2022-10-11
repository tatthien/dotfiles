set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/adb-fastboot/platform-tools $PATH
set -gx PATH $HOME/.deno/bin $PATH
set -gx PATH $HOME/flutter/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx EDITOR nvim
set -gx PNPM_HOME "/Users/thien/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH

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

# Serverless
alias s='serverless'

# Vim
alias vim='nvim'
alias evim='vim ~/dotfiles/nvim/'

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

alias znv "cd $HOME/Dropbox/notes && vim"
#----- ALIAS ------


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc'; end

# pnpm
set -gx PNPM_HOME "/Users/thien/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

#--- FUNCTIONS ------
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
