# dotfiles

## 快速开始（宿主机）
```bash
git clone <你的仓库地址> ~/any/path/dotfiles
cd ~/any/path/dotfiles
make macos-bootstrap
make macos-doctor
```

## 快速开始（容器，单镜像方式）
```bash
cd ~/any/path/dotfiles
make build-image-amd64   # 构建本地 amd64 镜像（用于 x86 机器）
make build-image-arm64   # 构建本地 arm64 镜像（用于 ARM 机器）
# 如 Docker Hub 网络不稳，可切换基础镜像源：
# BASE_IMAGE=<可访问镜像源>/debian:bookworm-slim make build-image-amd64
# 如需升级 Go 到更新稳定版（无需改 Dockerfile）：
# GO_VERSION=<x.y.z> make build-image-amd64
# 导出可传到离线/内网服务器的 amd64 tar：
# make export-image-amd64
# 或者：make pull-image 仅拉取远端镜像
# 发布多架构镜像（amd64+arm64）：
# make push-image
make smoke
make up            # 启动容器 terminal-env
make up-host       # Linux: 使用宿主机网络启动（会重建同名容器）
make shell         # 进入已启动容器（bash）

# 用完清理容器资源
make clean
```
目录映射调整说明见 [docker/README.md](./docker/README.md) 的“本地目录变动怎么改”。

仓库路径不要求固定；只要在仓库根目录执行这些命令即可。

## 常用命令
```bash
# macOS 宿主机恢复
make macos-bootstrap
make macos-bootstrap-dry-run

# 执行环境自检（失败返回非 0）
make macos-doctor

# 手动同步点文件（把系统配置软链到当前仓库，含 ~/.zshrc）
make dotfile-bootstrap

# 容器环境（不污染宿主机）
make build-image-amd64
make build-image-arm64
make export-image-amd64
make pull-image
make push-image
make smoke
make up
make up-host
make shell
make bootstrap
make ps
make logs
make clean
```

详细说明：
- macOS: [macos/README.md](./macos/README.md)
- Container: [docker/README.md](./docker/README.md)

## 目录结构
```text
dotfiles/
├── Makefile
├── macos/                    # macOS 脚本与文档
├── linux/                    # Linux 点文件同步脚本
├── docker/                   # Docker 相关脚本与文档
├── docker-compose.yml
└── .shell_env/.shell_aliases/.gitconfig/.bash_profile/.bashrc/.wezterm.lua/.config（可选 .zshrc）
```

## Shell 结构
- `.shell_env`：bash/zsh 共享环境，放 PATH、`JAVA_HOME`、`GOPATH`、JetBrains hook
- `.shell_aliases`：bash/zsh 共享 alias
- `.gitconfig`：Git 全局配置，统一管理 alias、URL rewrite、safe.directory
- `.bash_profile`：bash login shell 入口，负责加载共享环境、共享 alias、本地覆盖和 `.bashrc`
- `.bashrc`：bash 交互配置
- `.zshrc`：zsh 交互配置，直接加载共享环境和共享 alias，不再依赖 `.bash_profile`

## Git Alias
- `git st`：`git status`
- `git ss`：紧凑视图查看状态和当前分支，等价于 `git status --short --branch`
- `git co`：`git checkout`
- `git sw <branch>`：切换分支，等价于 `git switch <branch>`
- `git sc <branch>`：创建并切换到新分支，等价于 `git switch -c <branch>`
- `git cm`：`git commit`
- `git cmm "msg"`：快速单行提交，等价于 `git commit -m "msg"`
- `git br`：`git branch`
- `git rw <file>`：撤销工作区改动，等价于 `git restore --worktree -- <file>`
- `git rs <file>`：取消暂存但保留文件改动，等价于 `git restore --staged -- <file>`
- `git last`：查看最近一次提交及改动摘要，等价于 `git log -1 --stat`
- `git lg`：图形化单行历史，等价于 `git log --graph --decorate --oneline --all`
- `git aliases`：列出当前 alias

## Neovim 增加一种语言支持
- LSP server 列表在 [`.config/nvim/lua/configs.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/configs.lua:1) 的 `lspconfig_ensure_installed`
- 如果该 server 走系统安装，再同时加入 `system_managed_lsp_servers`
- 如果该语言需要专属配置，就新增 [`.config/nvim/lua/langs`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/langs) 下对应的 `<server>.lua`
- `configs.lua` 会自动执行 `require("langs." .. server)`，所以只要文件名和 server 名一致就会生效
- 如果该语言还需要 formatter / treesitter / dap / test，再分别补到：
  - [`.config/nvim/lua/stacks/format.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/format.lua:1)
  - [`.config/nvim/lua/stacks/treesitter.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/treesitter.lua:1)
  - [`.config/nvim/lua/stacks/tools.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/tools.lua:1)
  - [`.config/nvim/lua/stacks/editor.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/editor.lua:1)
- 例如当前已经接入的 `clangd`：
  - LSP 走 `clangd`
  - 格式化优先走 LSP；如果没有 formatting capability 且系统里装了 `clang-format`，则回退到 `clang-format`

## Neovim 目标结构
- [`.config/nvim/lua/configs.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/configs.lua:1)
  只做总装配，负责拼出最终配置，不再承载大段具体实现
- [`.config/nvim/lua/stacks/lsp.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/lsp.lua:1)
  原生 LSP 主链：`vim.lsp.config/enable`、diagnostic、hover、on_attach、LSP keymaps
- [`.config/nvim/lua/langs`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/langs)
  语言专属 LSP 配置，每个 server 一个文件
- [`.config/nvim/lua/stacks/format.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/format.lua:1)
  格式化策略：LSP formatting 优先，外部 formatter 兜底
- [`.config/nvim/lua/stacks/treesitter.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/treesitter.lua:1)
  原生 treesitter 运行时接线，以及 parser 安装管理
- [`.config/nvim/lua/stacks/tools.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/tools.lua:1)
  安装和开发工具链：`mason`、`dap`、`dap-go`
- [`.config/nvim/lua/stacks/editor.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/editor.lua:1)
  编辑体验增强：原生 completion/snippet、`autopairs`、`neotest`
- [`.config/nvim/lua/stacks/ui.lua`](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/ui.lua:1)
  界面与导航：`telescope`、`which-key`、`trouble`、`nvim-tree`、`bufferline`、`lualine`

## Neovim 快捷键

- 速查文档见 [.config/nvim/README.md](/Users/didi/workspace/src/dotfiles/.config/nvim/README.md:1)
