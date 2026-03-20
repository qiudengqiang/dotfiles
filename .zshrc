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
if [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
  # Fallback prompt when oh-my-zsh is unavailable (common in minimal Linux containers).
  PROMPT='%n@%m:%~%# '
fi

# Zsh behavior
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD

# Autosuggestion
bindkey '^_' autosuggest-accept
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
PROMPT='%F{red}%n@%m%f:%F{green}%2~%f%F{yellow}$(git_prompt_info)%f%# '
# Local-only overrides (not committed)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
