#!/usr/bin/env bash

[[ -f "$HOME/.shell_env" ]] && . "$HOME/.shell_env"
[[ -f "$HOME/.shell_aliases" ]] && . "$HOME/.shell_aliases"

# Optional local/private overrides (company hosts, secrets, proxies, etc.)
if [[ -f "$HOME/.bash_profile.local" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.bash_profile.local"
fi

# Load bash-only interactive config when running bash.
if [[ -n "${BASH_VERSION:-}" && -f "$HOME/.bashrc" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.bashrc"
fi
