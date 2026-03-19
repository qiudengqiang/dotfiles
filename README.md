# dotfile

## 快速开始（宿主机）
```bash
git clone <你的仓库地址> ~/workspace/github/dotfile
cd ~/workspace/github/dotfile
make macos-bootstrap
make macos-doctor
```

## 快速开始（容器，单镜像方式）
```bash
cd ~/workspace/github/dotfile
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

## 常用命令
```bash
# macOS 宿主机恢复
make macos-bootstrap
make macos-bootstrap-dry-run

# 执行环境自检（失败返回非 0）
make macos-doctor

# 手动同步点文件（把系统配置软链到当前仓库）
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
dotfile/
├── Makefile
├── macos/                    # macOS 脚本与文档
├── linux/                    # Linux 点文件同步脚本
├── docker/                   # Docker 相关脚本与文档
├── docker-compose.yml
└── .bash_profile/.bashrc/.wezterm.lua/.config（可选 .zshrc）
```
