#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"
OS="$(uname -s)"
DISTRO_ID="n/a"
DISTRO_VERSION="n/a"

RED='\033[0;31m'
YEL='\033[0;33m'
GRN='\033[0;32m'
NC='\033[0m'

fail_count=0
warn_count=0

ok() { printf "${GRN}[OK]${NC} %s\n" "$*"; }
warn() { warn_count=$((warn_count + 1)); printf "${YEL}[WARN]${NC} %s\n" "$*"; }
fail() { fail_count=$((fail_count + 1)); printf "${RED}[FAIL]${NC} %s\n" "$*"; }

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "命令存在: $cmd ($(command -v "$cmd"))"
  else
    fail "缺少命令: $cmd"
  fi
}

check_cmd_optional() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "命令存在: $cmd ($(command -v "$cmd"))"
  else
    warn "可选命令未安装: $cmd"
  fi
}

check_fd_compatible() {
  if command -v fd >/dev/null 2>&1; then
    ok "命令存在: fd ($(command -v fd))"
    return
  fi
  if command -v fdfind >/dev/null 2>&1; then
    ok "命令存在: fdfind ($(command -v fdfind))"
    return
  fi
  warn "可选命令未安装: fd/fdfind"
}

check_package_manager() {
  if [[ "$OS" == "Darwin" ]]; then
    check_cmd brew
    return
  fi

  if [[ "$OS" == "Linux" ]]; then
    if command -v brew >/dev/null 2>&1 || command -v apt-get >/dev/null 2>&1 || command -v pacman >/dev/null 2>&1 || command -v zypper >/dev/null 2>&1 || command -v apk >/dev/null 2>&1; then
      ok "包管理器可用"
    else
      fail "缺少可识别包管理器（brew/apt/pacman/zypper/apk）"
    fi
    return
  fi

  warn "未覆盖的系统类型: $OS"
}

check_link_or_file() {
  local target_rel="$1"
  local home_path="$HOME_DIR/$target_rel"
  local repo_path="$REPO_DIR/$target_rel"

  if [[ -L "$home_path" ]]; then
    local actual
    actual="$(readlink "$home_path")"
    if [[ "$actual" == "$repo_path" ]]; then
      ok "软链接正确: $home_path -> $repo_path"
    else
      warn "软链接目标不是仓库版本: $home_path -> $actual"
    fi
    return
  fi

  if [[ -e "$home_path" ]]; then
    warn "存在但不是软链接: $home_path"
  else
    fail "缺少文件: $home_path"
  fi
}

check_meslo_nerd_font() {
  local font_paths=(
    "$HOME_DIR/Library/Fonts/MesloLGLNerdFont-Regular.ttf"
    "/Library/Fonts/MesloLGLNerdFont-Regular.ttf"
  )

  local found_path=""
  for path in "${font_paths[@]}"; do
    if [[ -f "$path" ]]; then
      found_path="$path"
      break
    fi
  done

  if [[ -n "$found_path" ]]; then
    ok "发现 Nerd Font: $found_path"
  else
    fail "缺少 MesloLGL Nerd Font，请执行: brew install --cask font-meslo-lg-nerd-font"
  fi

  local wezterm_path="$HOME_DIR/.wezterm.lua"
  if [[ ! -f "$wezterm_path" ]]; then
    warn "未发现 WezTerm 配置: $wezterm_path"
    return
  fi

  local font_name
  font_name="$(sed -n 's/.*wezterm\.font("\([^"]*\)").*/\1/p' "$wezterm_path" | head -n 1)"
  if [[ -z "$font_name" ]]; then
    warn "未能从 WezTerm 配置中解析字体名: $wezterm_path"
    return
  fi

  if [[ "$font_name" == "MesloLGL Nerd Font" ]]; then
    ok "WezTerm 字体配置正确: $font_name"
  else
    warn "WezTerm 当前字体不是 MesloLGL Nerd Font: $font_name"
  fi
}

check_nvim_health_hint() {
  if ! command -v nvim >/dev/null 2>&1; then
    return
  fi

  local nvim_ver
  nvim_ver="$(nvim --version | head -n 1 | awk '{print $2}' | sed 's/^v//')"
  if [[ -n "$nvim_ver" ]]; then
    local major minor
    major="$(echo "$nvim_ver" | cut -d. -f1)"
    minor="$(echo "$nvim_ver" | cut -d. -f2)"
    if [[ "${major:-0}" -eq 0 && "${minor:-0}" -lt 10 ]]; then
      warn "Neovim 版本较低: v$nvim_ver（建议 >= 0.10）"
    else
      ok "Neovim 版本: v$nvim_ver"
    fi
  fi

  local lock_file="$HOME_DIR/.config/nvim/lazy-lock.json"
  if [[ -f "$lock_file" ]]; then
    ok "发现 lazy-lock: $lock_file"
  else
    warn "未找到 lazy-lock.json: $lock_file"
  fi

  local lazy_dir="$HOME_DIR/.local/share/nvim/lazy"
  if [[ -d "$lazy_dir" ]]; then
    ok "发现插件目录: $lazy_dir"
  else
    warn "未发现插件目录: $lazy_dir（首次启动 nvim 后会生成）"
  fi
}

check_copilot_hint() {
  local cp_file="$HOME_DIR/.config/github-copilot/apps.json"
  if [[ -f "$cp_file" ]]; then
    ok "发现 Copilot 鉴权文件: $cp_file"
  else
    warn "未发现 Copilot 鉴权文件，可在 nvim 执行 :Copilot auth signin"
  fi
}

check_external_tools_optional() {
  check_cmd_optional prettier
  check_cmd_optional black
  check_cmd_optional stylua
  check_cmd_optional dlv
}

detect_linux_distro() {
  if [[ "$OS" != "Linux" ]]; then
    return
  fi
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO_ID="${ID:-unknown}"
    DISTRO_VERSION="${VERSION_ID:-unknown}"
  fi
}

main() {
  local total_checks=6
  detect_linux_distro
  echo "== Dotfile Doctor =="
  echo "os: $OS"
  if [[ "$OS" == "Linux" ]]; then
    echo "distro: $DISTRO_ID $DISTRO_VERSION"
  fi
  echo "repo: $REPO_DIR"
  echo "home: $HOME_DIR"
  echo

  echo "[1/${total_checks}] 关键软链接"
  check_link_or_file ".bash_profile"
  check_link_or_file ".bashrc"
  check_link_or_file ".zshrc"
  check_link_or_file ".config/nvim"
  if [[ "$OS" == "Darwin" ]]; then
    check_link_or_file ".wezterm.lua"
  fi
  echo

  echo "[2/${total_checks}] 基础命令"
  check_package_manager
  check_cmd git
  check_cmd nvim
  check_cmd rg
  check_fd_compatible
  check_cmd_optional node
  echo

  echo "[3/${total_checks}] 终端字体"
  if [[ "$OS" == "Darwin" ]]; then
    check_meslo_nerd_font
  else
    warn "字体检查目前仅覆盖 macOS"
  fi
  echo

  echo "[4/${total_checks}] Neovim"
  check_nvim_health_hint
  echo

  echo "[5/${total_checks}] Copilot"
  check_copilot_hint
  echo

  echo "[6/${total_checks}] 外部工具"
  check_external_tools_optional
  echo

  echo "== Summary =="
  echo "failed checks : $fail_count"
  echo "warning checks: $warn_count"

  if [[ "$fail_count" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
