# Vendored Fonts

This directory vendors the minimal MesloLGL Nerd Font set required by this dotfiles repository.

Included files:
- `MesloLGLNerdFont-Regular.ttf`
- `MesloLGLNerdFont-Italic.ttf`
- `MesloLGLNerdFont-Bold.ttf`
- `MesloLGLNerdFont-BoldItalic.ttf`

These files are installed by `macos/bootstrap.sh` into `~/Library/Fonts` so `WezTerm` and `Neovim` icons work on a fresh macOS machine without waiting for Homebrew to fetch the full Nerd Fonts cask from GitHub releases.

Upstream:
- Nerd Fonts release `v3.4.0`
- Meslo LG upstream: <https://github.com/andreberg/Meslo-Font>

If you refresh these files, keep `LICENSE.txt` in sync.
