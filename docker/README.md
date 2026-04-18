# 容器化恢复（单镜像方案）

## 目标
在不污染宿主机的前提下，复现你的 terminal + nvim 使用习惯。

核心原则：
- 只维护一个固定镜像标签：`vinoqiu/terminal-env:stable`（本地按架构通过 `make build-image-amd64` / `make build-image-arm64` 构建）
- 默认基础镜像使用 `debian:bookworm-slim`（最小可用，专注 Neovim 开发依赖）
- 宿主机发行版无关（macOS/Linux 均可），统一使用同一个镜像标签
- 只要宿主机能运行 Docker，即可拉起同一套环境

## 前置条件
- Docker 或 Docker Desktop 已安装并已启动
- 仓库在本机：`~/workspace/github/dotfile`
- 建议至少预留 10GB 磁盘空间（首次构建或拉取镜像）

## 一键命令（推荐）
```bash
cd ~/workspace/github/dotfile

# 本地重建镜像（按架构）
make build-image-amd64
make build-image-arm64

# 如 Docker Hub 网络波动，可切换基础镜像源
BASE_IMAGE=<可访问镜像源>/debian:bookworm-slim make build-image-amd64

# 如需升级 Go 到更新稳定版（无需改 Dockerfile）
GO_VERSION=<x.y.z> make build-image-amd64

# 导出 amd64 tar（给无法访问 Docker Hub 的服务器）
make export-image-amd64

# 仅拉取远端镜像
make pull-image

# 推送镜像到dockerhub（默认发布 linux/amd64 + linux/arm64 多架构）
make push-image

# 烟雾测试（输出 nvim/node/rg/fd/fzf/prettier/black/stylua/dlv 版本）
make smoke

# 启动容器（名称默认 terminal-env）
make up

# Linux 可选：使用宿主机网络启动（会重建同名容器）
make up-host

# 进入交互环境（仅进入已运行容器）
make shell

# 进入容器后手动同步当前仓库 dotfiles 到系统 HOME
make dotfile-bootstrap

# 仅做软链映射初始化（不进入 shell）
make bootstrap

# 查看容器与日志（可选）
make ps
make logs

# 用完清理容器资源
make clean
```

## 直接 docker 命令（可选）
```bash
cd ~/workspace/github/dotfile

# 本地构建
docker buildx build \
  --platform linux/amd64 \
  --build-arg BASE_IMAGE=debian:bookworm-slim \
  --build-arg GO_VERSION=1.24.3 \
  -f docker/Dockerfile.debian-bookworm \
  -t vinoqiu/terminal-env:stable \
  --load .

# 进入环境
docker run -it --rm \
  -v "$PWD":/opt/dotfile \
  -v "$HOME":/work \
  -w /work \
  vinoqiu/terminal-env:stable \
  bash -l
```

## 发布到 Docker Hub
```bash
# 登录
docker login

# 发布多架构镜像到 Docker Hub
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg BASE_IMAGE=debian:bookworm-slim \
  --build-arg GO_VERSION=1.24.3 \
  -f docker/Dockerfile.debian-bookworm \
  -t vinoqiu/terminal-env:stable \
  --push .

# 验证远端 manifest
docker manifest inspect vinoqiu/terminal-env:stable
```

## 容器行为说明
- 启动时会自动执行 dotfile 映射：
  - `~/.shell_env -> /opt/dotfile/.shell_env`
  - `~/.shell_aliases -> /opt/dotfile/.shell_aliases`
  - `~/.gitconfig -> /opt/dotfile/.gitconfig`
  - `~/.bash_profile -> /opt/dotfile/.bash_profile`
  - `~/.bashrc -> /opt/dotfile/.bashrc`
  - `~/.config/nvim -> /opt/dotfile/.config/nvim`
- 默认进入 `bash -l`
- `make up` 负责通过 compose 启动容器（bridge 网络）
- `make up-host`（Linux 专用）通过 `docker run --network host` 启动容器，会重建同名容器
- `make shell` 只负责进入容器
- `make dotfile-bootstrap` 可手动执行一次，把 `~/.shell_env`、`~/.shell_aliases`、`~/.gitconfig`、`~/.bash_profile`、`~/.bashrc`、`~/.zshrc`、`~/.config/nvim`、`~/.wezterm.lua` 链接到当前仓库
- 首次 `make up` 会自动预热 Neovim（Lazy 插件 + Mason 常用工具），首次耗时会更长
- 宿主机目录映射：
  - 仓库映射到容器 `/opt/dotfile`
  - `~` 映射到容器 `/work`

## 本地目录变动怎么改
如果你本地目录结构变了，修改 `docker-compose.yml` 的 `services.dev.volumes` 左侧宿主机路径即可。

当前默认：
```yaml
volumes:
  - .:/opt/dotfile
  - ${HOME}:/work
```

常见改法：
1. 不想挂载整个 `HOME`，只挂载一个代码目录
```yaml
volumes:
  - .:/opt/dotfile
  - /你的实际路径:/work
```

2. 需要挂载多个代码目录
```yaml
volumes:
  - .:/opt/dotfile
  - /path/a:/work/a
  - /path/b:/work/b
```

3. 只想要 dotfile，不挂载 workspace
```yaml
volumes:
  - .:/opt/dotfile
```

改完后重新执行 `make up`（必要时先 `make clean`）再 `make shell` 即可生效。

## 验收标准
进入容器后执行以下命令，均应有版本输出且返回 0：
```bash
nvim --version | head -n1
node --version
rg --version | head -n1
fd --version
fzf --version
prettier --version
black --version
stylua --version
dlv version | head -n1
```

## 常见问题与排查

### 1) 镜像仓库网络波动
现象：
- `failed to fetch oauth token`
- `i/o timeout`

排查：
```bash
docker info
curl -I https://auth.docker.io/token
```

建议处理：
- 重试
- 检查代理/公司网络策略
- 检查 Docker daemon 的 registry mirror 配置
- 构建时切换基础镜像源：
```bash
BASE_IMAGE=<可访问镜像源>/debian:bookworm-slim make build-image-amd64
```

### 2) Apple Silicon 机器（M 系列）
- 如果你使用的是 `amd64` 镜像，会走仿真，速度可能变慢
- 优先使用支持多架构的镜像标签
