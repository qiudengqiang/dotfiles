# dotfile

## 快速开始（宿主机）
```bash
git clone <你的仓库地址> ~/workspace/github/dotfile
cd ~/workspace/github/dotfile
make macos
make doctor
```

## 快速开始（容器，单镜像方式）
```bash
cd ~/workspace/github/dotfile
make build-image   # 本地重建镜像（默认 Debian slim 基础镜像）
# 如 Docker Hub 网络不稳，可切换基础镜像源：
# BASE_IMAGE=<可访问镜像源>/debian:bookworm-slim make build-image
# 如需升级 Go 到更新稳定版（无需改 Dockerfile）：
# GO_VERSION=<x.y.z> make build-image
# 或者：make pull-image 仅拉取远端镜像
make smoke
make shell         # 复用正在运行的 dotfile-dev；没有则自动创建

# 用完清理容器资源
make clean
```
目录映射调整说明见 [docker/README.md](./docker/README.md) 的“本地目录变动怎么改”。

## 常用命令
```bash
# macOS 宿主机恢复
make macos
make macos-dry-run

# 执行环境自检（失败返回非 0）
make doctor

# 容器环境（不污染宿主机）
make build-image
make pull-image
make push-image
make smoke
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
├── docker/                   # Docker 相关脚本与文档
├── docker-compose.yml
└── .bash_profile/.bashrc/.zshrc/.wezterm.lua/.config
```
