# 新 Mac 恢复（Terminal + Neovim）

## 目标
一条命令恢复：
- `~/.shell_env`
- `~/.shell_aliases`
- `~/.gitconfig`
- `~/.bash_profile`
- `~/.bashrc`
- `~/.zshrc`
- `~/.wezterm.lua`
- `~/.config/nvim`
- 常用工具（Homebrew + Brewfile）

## 0. 前置
- 登录 iCloud / GitHub
- 安装 Xcode Command Line Tools（脚本会检测并提示）

## 1. 拉取 dotfiles 仓库
```bash
git clone <你的仓库地址> ~/any/path/dotfiles
cd ~/any/path/dotfiles
```

仓库可以放在任意目录，不要求固定是 `~/workspace/src/dotfiles`。

## 2. 执行一键恢复
```bash
make macos-bootstrap
```

先预演（不做修改）：
```bash
make macos-bootstrap-dry-run
```

脚本会做这些事：
1. 检查并安装 Xcode CLT
2. 检查并安装 Homebrew
3. `brew bundle --file macos/Brewfile` 安装工具
4. 从仓库内置的 `assets/fonts/` 安装 `MesloLGL Nerd Font`（缺失时才回退到 `brew install --cask font-meslo-lg-nerd-font`）
5. 检查并补齐 Neovim 外部工具（`prettier`/`clang-format`/`stylua`/`delve`，`black` 走 `pipx/pip` 回退安装）
6. 备份已有配置到 `~/.dotfiles_bak/<时间戳>/`
7. 建立软链接：
   - `~/.shell_env -> <repo>/.shell_env`
   - `~/.shell_aliases -> <repo>/.shell_aliases`
   - `~/.gitconfig -> <repo>/.gitconfig`
   - `~/.bash_profile -> <repo>/.bash_profile`
   - `~/.bashrc -> <repo>/.bashrc`
   - `~/.zshrc -> <repo>/.zshrc`
   - `~/.wezterm.lua -> <repo>/.wezterm.lua`
   - `~/.config/nvim -> <repo>/.config/nvim`

## 3. 恢复后自检
```bash
source ~/.zshrc
make macos-doctor
nvim --version
nvim
```

进入 nvim 后：
- 等待插件自动安装
- Copilot 首次登录：`:Copilot auth signin`
- 查看状态：`:Copilot status`

## 4. Terminal / iTerm2 / WezTerm Meta 键设置
为了让 Neovim 识别 `Alt/Option` 组合键：
- Terminal.app: 设置 -> 配置描述文件 -> 键盘 -> 勾选 `Use Option as Meta key`
- iTerm2: Profiles -> Keys -> Left/Right Option Key -> `Esc+`
- WezTerm: 通过 `~/.wezterm.lua` 配置（本仓库已托管）

## 5. 终端字体设置
如果 `nvim` 里文件图标、diagnostic 图标、git 图标显示成方块或乱码，通常就是终端没有使用 Nerd Font：
- WezTerm: `~/.wezterm.lua` 已默认指定 `MesloLGL Nerd Font`，只要字体安装成功即可
- iTerm2: Profiles -> Text -> Font，选择 `MesloLGL Nerd Font`
- Terminal.app: 设置 -> 配置描述文件 -> 文本 -> 字体，选择 `MesloLGL Nerd Font`
- 仓库已内置最小字体集在 `assets/fonts/`，避免新机器初始化时卡在 GitHub 下载字体包

执行自检时也会检查字体：
```bash
make macos-doctor
```

## 6. 回滚
如果需要回滚：
- 备份目录在 `~/.dotfiles_bak/<时间戳>/`
- 手动把对应文件移回原位即可

## 7. 私有配置建议
- 把公司内网机器 alias、私有代理、敏感环境变量放到 `~/.bash_profile.local` 或 `~/.zshrc.local`
- 仓库里提供了模板：`.bash_profile.local.example`、`.zshrc.local.example`
- `.bash_profile.local` 与 `.zshrc.local` 已在 `.gitignore` 中忽略，不会被提交
