#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-/opt/dotfile}"
HOME_DIR="${HOME:-/root}"

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
  local src="$DOTFILES_DIR/$rel"
  local dst="$HOME_DIR/$rel"

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
    mv "$dst" "${dst}.bak.$(date +%s)"
    info "backup created: ${dst}.bak.*"
  fi

  ln -s "$src" "$dst"
  info "linked: $dst -> $src"
}

bootstrap_shell_only() {
  ensure_fd_compat
  link_item ".shell_env"
  link_item ".shell_aliases"
  link_item ".gitconfig"
  link_item ".bash_profile"
  link_item ".bashrc"
  link_item ".config/nvim"
}

ensure_nvim_ready_once() {
  local marker="${HOME_DIR}/.local/share/nvim/.dotfile_bootstrap_done"
  if [[ "${NVIM_BOOTSTRAP_ON_START:-1}" != "1" ]]; then
    return
  fi
  if [[ -f "$marker" ]]; then
    return
  fi
  if ! command -v nvim >/dev/null 2>&1; then
    return
  fi

  info "Bootstrapping Neovim plugins and LSP tools (first run)..."
  if nvim --headless "+Lazy! sync" \
    "+MasonInstall gopls bash-language-server yaml-language-server lua-language-server prettier black stylua delve" \
    "+qa" >/tmp/nvim-bootstrap.log 2>&1; then
    mkdir -p "$(dirname "$marker")"
    touch "$marker"
    info "Neovim bootstrap done"
  else
    warn "Neovim bootstrap failed, check /tmp/nvim-bootstrap.log"
  fi
}

main() {
  if [[ "${1:-}" == "bootstrap" ]]; then
    bootstrap_shell_only
    exit 0
  fi

  if [[ "${BOOTSTRAP_DOTFILES:-1}" == "1" ]]; then
    bootstrap_shell_only
    if [[ $# -eq 0 ]]; then
      ensure_nvim_ready_once
    fi
  fi

  if [[ $# -gt 0 ]]; then
    exec "$@"
  fi

  exec bash -l
}

main "$@"
