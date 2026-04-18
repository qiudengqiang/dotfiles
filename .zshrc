# Shared environment and aliases
[[ -f "$HOME/.shell_env" ]] && source "$HOME/.shell_env"
[[ -f "$HOME/.shell_aliases" ]] && source "$HOME/.shell_aliases"

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

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
  PROMPT='%F{red}%n@%m%f:%F{green}%2~%f$(git_prompt_info)%# '
else
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
# Local-only overrides (not committed)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
