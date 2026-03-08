#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_ROOT="$HOME/.dotfiles_bak"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
MODE="apply"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

parse_args() {
  case "${1:-}" in
    "")
      MODE="apply"
      ;;
    --dry-run)
      MODE="dry-run"
      ;;
    --apply)
      MODE="apply"
      ;;
    *)
      echo "Usage: $0 [--dry-run|--apply]"
      exit 2
      ;;
  esac
}

print_plan() {
  info "[dry-run] Would run bootstrap-macos.sh with these steps:"
  info "[dry-run] 1) Ensure Xcode CLT"
  info "[dry-run] 2) Ensure Homebrew"
  info "[dry-run] 3) Install Brewfile packages"
  info "[dry-run] 4) Ensure external tools: prettier/black/stylua/dlv"
  info "[dry-run] 5) Ensure Oh My Zsh + plugins"
  for target in ".bash_profile" ".bashrc" ".zshrc" ".config/nvim"; do
    local src="$REPO_DIR/$target"
    local dst="$HOME/$target"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
      info "[dry-run] Link already correct: $dst -> $src"
    elif [[ -e "$dst" || -L "$dst" ]]; then
      info "[dry-run] Would backup then link: $dst -> $src"
    else
      info "[dry-run] Would create link: $dst -> $src"
    fi
  done
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    info "Xcode Command Line Tools already installed"
    return
  fi

  warn "Xcode Command Line Tools not found, installing..."
  xcode-select --install || true
  warn "请在弹窗完成安装后，重新执行本脚本。"
  exit 1
}

ensure_homebrew() {
  if need_cmd brew; then
    info "Homebrew already installed"
    return
  fi

  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_brew_packages() {
  local brewfile="$REPO_DIR/macos/Brewfile"
  if [[ ! -f "$brewfile" ]]; then
    warn "Brewfile not found, skip brew bundle"
    return
  fi

  info "Installing packages from Brewfile"
  if ! brew bundle --file "$brewfile"; then
    warn "brew bundle has failures; continue with fallback installers."
  fi
}

ensure_external_tools() {
  local tools=(
    "prettier:prettier"
    "stylua:stylua"
    "dlv:delve"
  )

  for entry in "${tools[@]}"; do
    local cmd="${entry%%:*}"
    local formula="${entry##*:}"
    if need_cmd "$cmd"; then
      info "Tool already installed: $cmd"
      continue
    fi

    info "Installing external tool: $formula (for $cmd)"
    if ! brew install "$formula"; then
      warn "Install failed for $formula, please install manually."
      continue
    fi

    if need_cmd "$cmd"; then
      info "Tool installed: $cmd"
    else
      warn "Tool still missing after install: $cmd"
    fi
  done

  if ! need_cmd black; then
    info "Installing external tool: black (pipx/pip fallback)"
    if need_cmd pipx; then
      if ! pipx install --force black >/dev/null 2>&1; then
        warn "pipx install black failed"
      fi
    elif need_cmd python3; then
      if ! python3 -m pip install --user --upgrade black >/dev/null 2>&1; then
        warn "python3 -m pip install --user black failed"
      fi
    else
      warn "Neither pipx nor python3 is available; cannot install black automatically."
    fi
  fi

  if need_cmd black; then
    info "Tool installed: black"
  else
    warn "Tool still missing after fallback install: black"
  fi
}

print_external_tools_status() {
  local tools=(prettier black stylua dlv)

  info "External tools status:"
  for cmd in "${tools[@]}"; do
    if need_cmd "$cmd"; then
      local ver
      ver="$("$cmd" --version 2>/dev/null | head -n 1 || true)"
      if [[ -z "$ver" ]]; then
        ver="$("$cmd" version 2>/dev/null | head -n 1 || true)"
      fi
      if [[ -z "$ver" ]]; then
        ver="version unknown"
      fi
      info "  - $cmd: $ver"
    else
      warn "  - $cmd: missing"
    fi
  done
}

ensure_oh_my_zsh() {
  local zsh_dir="${ZSH:-$HOME/.oh-my-zsh}"
  if [[ -d "$zsh_dir" ]]; then
    info "Oh My Zsh already installed"
    return
  fi

  info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || warn "Oh My Zsh install failed"
}

ensure_omz_plugins() {
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$zsh_custom/plugins"

  if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions" || warn "zsh-autosuggestions install failed"
  fi

  if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom/plugins/zsh-syntax-highlighting" || warn "zsh-syntax-highlighting install failed"
  fi
}

backup_target() {
  local target="$1"

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    return
  fi

  mkdir -p "$BACKUP_DIR"
  local rel="${target#$HOME/}"
  local dst="$BACKUP_DIR/$rel"
  mkdir -p "$(dirname "$dst")"
  mv "$target" "$dst"
  info "Backed up: $target -> $dst"
}

link_item() {
  local src_rel="$1"
  local src="$REPO_DIR/$src_rel"
  local dst="$HOME/$src_rel"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    warn "Source not found, skip: $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      info "Already linked: $dst"
      return
    fi
  fi

  backup_target "$dst"
  ln -s "$src" "$dst"
  info "Linked: $dst -> $src"
}

main() {
  parse_args "${1:-}"
  if [[ "$MODE" == "dry-run" ]]; then
    print_plan
    return 0
  fi

  ensure_xcode_clt
  ensure_homebrew
  install_brew_packages
  ensure_external_tools
  print_external_tools_status
  ensure_oh_my_zsh
  ensure_omz_plugins

  link_item ".bash_profile"
  link_item ".bashrc"
  link_item ".zshrc"
  link_item ".config/nvim"

  info "Done"
  if [[ -d "$BACKUP_DIR" ]]; then
    info "Backup directory: $BACKUP_DIR"
  fi

  cat <<'EOT'

Next steps:
1) 重开终端，执行: source ~/.zshrc
2) 打开 nvim，等待 lazy.nvim 安装插件
3) 执行 :Copilot auth signin 完成 Copilot 登录

EOT
}

main "$@"
