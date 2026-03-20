#!/usr/bin/env bash

add_path() {
  for v in "$@"; do
    if [[ -d "$v" && ":${PATH}:" != *":${v}:"* ]]; then
      PATH="$v:$PATH"
    fi
  done
}

# Common PATH for macOS and Linux dev environments.
add_path \
  "/opt/homebrew/bin" \
  "/usr/local/bin" \
  "/home/linuxbrew/.linuxbrew/bin" \
  "$HOME/.linuxbrew/bin" \
  "$HOME/.local/bin"
export PATH

# Java: macOS via java_home, Linux via javac path.
if command -v /usr/libexec/java_home >/dev/null 2>&1; then
  JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null || true)"
elif command -v javac >/dev/null 2>&1; then
  JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")"
fi

if [[ -n "${JAVA_HOME:-}" ]]; then
  export JAVA_HOME
  add_path "$JAVA_HOME/bin"
  export PATH
fi

# Go defaults.
if command -v go >/dev/null 2>&1 || [[ -d /usr/local/go ]]; then
  export GOPATH="${GOPATH:-$HOME/workspace/go}"
  add_path "/usr/local/go/bin" "$GOPATH/bin"
  export PATH
fi

# If apt installs fd as fdfind, provide local alias command fd.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# JetBrains VM options hook.
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [[ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]]; then
  # shellcheck source=/dev/null
  . "${___MY_VMOPTIONS_SHELL_FILE}"
fi

# Generic aliases.
alias ll='ls -lha'
alias vi='nvim'
alias grep='grep --color'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias p3s='python3 -m http.server'

alias proxy_on='export http_proxy=http://127.0.0.1:7890; export https_proxy=http://127.0.0.1:7890; export all_proxy=socks5://127.0.0.1:7891; echo "🟢 Proxy ON"'
alias proxy_off='unset http_proxy; unset https_proxy; unset all_proxy; echo "🔴 Proxy OFF"'

alias loginexp='exec ~/workspace/data/script/login.exp'

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
