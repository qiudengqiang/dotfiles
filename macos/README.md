# 新 Mac 恢复（Terminal + Neovim）

## 目标
一条命令恢复：
- `~/.bash_profile`
- `~/.bashrc`
- `~/.zshrc`
- `~/.config/nvim`
- 常用工具（Homebrew + Brewfile）

## 0. 前置
- 登录 iCloud / GitHub
- 安装 Xcode Command Line Tools（脚本会检测并提示）

## 1. 拉取 dotfile 仓库
```bash
git clone <你的仓库地址> ~/workspace/github/dotfile
cd ~/workspace/github/dotfile
```

## 2. 执行一键恢复
```bash
make macos
```

先预演（不做修改）：
```bash
make macos-dry-run
```

脚本会做这些事：
1. 检查并安装 Xcode CLT
2. 检查并安装 Homebrew
3. `brew bundle --file macos/Brewfile` 安装工具
4. 检查并补齐 Neovim 外部工具（`prettier`/`stylua`/`delve`，`black` 走 `pipx/pip` 回退安装）
5. 备份已有配置到 `~/.dotfiles_bak/<时间戳>/`
6. 建立软链接：
   - `~/.bash_profile -> <repo>/.bash_profile`
   - `~/.bashrc -> <repo>/.bashrc`
   - `~/.zshrc -> <repo>/.zshrc`
   - `~/.config/nvim -> <repo>/.config/nvim`

## 3. 恢复后自检
```bash
source ~/.zshrc
make doctor
nvim --version
nvim
```

进入 nvim 后：
- 等待插件自动安装
- Copilot 首次登录：`:Copilot auth signin`
- 查看状态：`:Copilot status`

## 4. Terminal / iTerm2 Meta 键设置
为了让 Neovim 识别 `Alt/Option` 组合键：
- Terminal.app: 设置 -> 配置描述文件 -> 键盘 -> 勾选 `Use Option as Meta key`
- iTerm2: Profiles -> Keys -> Left/Right Option Key -> `Esc+`

## 5. 回滚
如果需要回滚：
- 备份目录在 `~/.dotfiles_bak/<时间戳>/`
- 手动把对应文件移回原位即可

## 6. 私有配置建议
- 把公司内网机器 alias、私有代理、敏感环境变量放到 `~/.bash_profile.local` 或 `~/.zshrc.local`
- 仓库里提供了模板：`.bash_profile.local.example`、`.zshrc.local.example`
- `.bash_profile.local` 与 `.zshrc.local` 已在 `.gitignore` 中忽略，不会被提交
