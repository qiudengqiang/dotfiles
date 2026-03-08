# 容器化恢复（单镜像方案）

## 目标
在不污染宿主机的前提下，复现你的 terminal + nvim 使用习惯。

核心原则：
- 只维护一个固定镜像标签：`vinoqiu/terminal-env:stable`（本地通过 `make build-image` 重新构建）
- 宿主机发行版无关（macOS/Linux 均可），统一使用同一个镜像标签
- 只要宿主机能运行 Docker，即可拉起同一套环境

## 前置条件
- Docker 或 Docker Desktop 已安装并已启动
- 仓库在本机：`~/workspace/github/dotfile`
- 建议至少预留 10GB 磁盘空间（首次构建或拉取镜像）

## 一键命令（推荐）
```bash
cd ~/workspace/github/dotfile

# 本地重建镜像（不依赖本地 assets 文件）
make build-image
# 仅拉取远端镜像：make pull-image

# 烟雾测试（输出 nvim/node/rg/fd/fzf/prettier/black/stylua/dlv 版本）
make smoke

# 进入交互环境（复用运行中的 dotfile-dev；不存在则自动创建）
make shell

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
docker compose build --pull --no-cache dev

# 进入环境
docker run -it --rm \
  -v "$PWD":/opt/dotfile \
  -v "$HOME/workspace":/workspace \
  -w /workspace \
  vinoqiu/terminal-env:stable \
  zsh -l
```

## 发布到 Docker Hub
```bash
# 登录
docker login

# 本地重建镜像
docker compose build --pull --no-cache dev

# 推送到 Docker Hub
docker push vinoqiu/terminal-env:stable
```

## 容器行为说明
- 启动时会自动执行 dotfile 映射：
  - `~/.bash_profile -> /opt/dotfile/.bash_profile`
  - `~/.bashrc -> /opt/dotfile/.bashrc`
  - `~/.zshrc -> /opt/dotfile/.zshrc`
  - `~/.config/nvim -> /opt/dotfile/.config/nvim`
- 默认进入 `zsh -l`
- `make shell` 会直接进入容器 shell，不需要额外登录
- 首次 `make shell` 会自动预热 Neovim（Lazy 插件 + Mason 常用工具），首次耗时会更长
- 宿主机目录映射：
  - 仓库映射到容器 `/opt/dotfile`
  - `~/workspace` 映射到容器 `/workspace`

## 本地目录变动怎么改
如果你本地目录结构变了，修改 `docker-compose.yml` 的 `services.dev.volumes` 左侧宿主机路径即可。

当前默认：
```yaml
volumes:
  - .:/opt/dotfile
  - ${HOME}/workspace:/workspace
```

常见改法：
1. `workspace` 不在 `~/workspace`
```yaml
volumes:
  - .:/opt/dotfile
  - /你的实际路径/workspace:/workspace
```

2. 需要挂载多个代码目录
```yaml
volumes:
  - .:/opt/dotfile
  - /path/a:/workspace/a
  - /path/b:/workspace/b
```

3. 只想要 dotfile，不挂载 workspace
```yaml
volumes:
  - .:/opt/dotfile
```

改完后重新执行 `make shell` 即可生效。

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

### 2) Apple Silicon 机器（M 系列）
- 如果你使用的是 `amd64` 镜像，会走仿真，速度可能变慢
- 优先使用支持多架构的镜像标签
