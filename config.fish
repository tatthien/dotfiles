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
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

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
alias gf='git fetch'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gh='git checkout'
alias glo='git log --oneline'
alias gfa='git fetch --all'
###### ALIAS ######

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/thien/Downloads/google-cloud-sdk/path.fish.inc'; end

###### COLORSCHEME ######
# Nightfox Color Palette
# Style: nightfox
# Upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/nightfox/nightfox_fish.fish
set -l foreground cdcecf
set -l selection 2b3b51
set -l comment 738091
set -l red c94f6d
set -l orange f4a261
set -l yellow dbc074
set -l green 81b29a
set -l purple 9d79d6
set -l cyan 63cdcf
set -l pink d67ad2

# Syntax Highlighting Colors
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

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
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

# pyenv
pyenv init - | source
