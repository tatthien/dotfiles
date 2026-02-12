# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  z
)

source $ZSH/oh-my-zsh.sh

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim="nvim"
alias g="gcloud"
alias gfa="git fetch --all"
alias gh="git checkout"
alias gsi="git stash --include-untracked"
alias dps="docker ps -a --format 'table {{.ID}}\\t{{.Names}}\\t{{.Status}}\t{{.Ports}}'"
alias dot="cd ~/dotfiles && vim"

# PATH
export PATH="/Users/thien.nguyen/.local/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thien.nguyen/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/thien.nguyen/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thien.nguyen/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/thien.nguyen/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Starship prompt
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# opencode
export PATH=/Users/thien.nguyen/.opencode/bin:$PATH

# pnpm
export PNPM_HOME="/Users/thien.nguyen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
