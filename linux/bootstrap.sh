#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
HOME_DIR="${HOME:-/root}"
BACKUP_TS="$(date +%s)"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }

ensure_fd_compat() {
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    mkdir -p "${HOME_DIR}/.local/bin"
    ln -sf "$(command -v fdfind)" "${HOME_DIR}/.local/bin/fd"
    info "linked: ${HOME_DIR}/.local/bin/fd -> $(command -v fdfind)"
  fi
}

link_item() {
  local rel="$1"
  local src="${DOTFILES_DIR}/${rel}"
  local dst="${HOME_DIR}/${rel}"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    warn "source missing, skip: $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      info "already linked: $dst"
      return
    fi
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "${dst}.bak.${BACKUP_TS}"
    info "backup created: ${dst}.bak.${BACKUP_TS}"
  fi

  ln -s "$src" "$dst"
  info "linked: $dst -> $src"
}

main() {
  ensure_fd_compat
  link_item ".shell_env"
  link_item ".shell_aliases"
  link_item ".gitconfig"
  link_item ".bash_profile"
  link_item ".bashrc"
  link_item ".zshrc"
  link_item ".config/nvim"
  link_item ".wezterm.lua"

  info "dotfiles bootstrap done"
  info "reload shell: source ~/.bash_profile"
}

main "$@"
