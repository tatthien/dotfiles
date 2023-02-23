set -gx EDITOR nvim
set -gx TERM xterm-256color-italic
set -gx VOLTA_HOME $HOME/.volta
set -gx PATH $HOME/go/bin $PATH
set -gx PATH $HOME/adb-fastboot/platform-tools $PATH
set -gx PATH $HOME/.deno/bin $PATH
set -gx PATH $HOME/flutter/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PNPM_HOME "/Users/thien/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH
set -gx PATH $PATH $HOME/.krew/bin
set -gx PATH $PATH $VOLTA_HOME
set -gx XDG_CONFIG_HOME $HOME/.config

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
alias vim='nvim'
alias evim='vim ~/dotfiles/nvim/'
if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end
###### ALIAS ######

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc'; end

###### COLORSCHEME ######
set -l foreground c0caf5
set -l selection 33467c
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection
###### COLORSCHEME ######

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
###### FUNCTIONS ######
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# pyenv
pyenv init - | source
