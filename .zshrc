# Shared environment and aliases
[[ -f "$HOME/.bash_profile" ]] && source "$HOME/.bash_profile"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="daveverwer"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Optional: reduce update noise
# zstyle ':omz:update' mode reminder

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Zsh behavior
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD

# Autosuggestion
bindkey '^_' autosuggest-accept
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Local-only overrides (not committed)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
