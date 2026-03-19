.PHONY: macos-bootstrap macos-bootstrap-dry-run macos-doctor up shell bootstrap smoke build-image-amd64 build-image-arm64 export-image-amd64 pull-image push-image ps logs clean

BASE_IMAGE ?= debian:bookworm-slim
GO_VERSION ?= 1.24.3
PUSH_PLATFORMS ?= linux/amd64,linux/arm64
IMAGE ?= vinoqiu/terminal-env:stable
EXPORT_TAR_AMD64 ?= terminal-env-stable-linux-amd64.tar
CONTAINER_NAME ?= terminal-env

macos-bootstrap:
	./macos/bootstrap.sh

macos-bootstrap-dry-run:
	./macos/bootstrap.sh --dry-run

macos-doctor:
	./macos/doctor.sh

up:
	CONTAINER_NAME=$(CONTAINER_NAME) docker compose up -d dev

shell:
	@set -e; \
	if docker ps --filter "name=^/$(CONTAINER_NAME)$$" --format '{{.Names}}' | grep -q '^$(CONTAINER_NAME)$$'; then \
	  docker exec -it $(CONTAINER_NAME) zsh -l; \
	else \
	  echo "[ERROR] container $(CONTAINER_NAME) is not running. run: make up"; \
	  exit 1; \
	fi

bootstrap:
	docker compose run --rm dev bootstrap

smoke:
	docker compose run --rm dev bash -lc 'set -euo pipefail; nvim --version | head -n1; node --version; rg --version | head -n1; fd --version; fzf --version; prettier --version; black --version; stylua --version; dlv version | head -n1'

build-image-amd64:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg GO_VERSION=$(GO_VERSION) \
		-f docker/Dockerfile.debian-bookworm \
		-t $(IMAGE) \
		--load .

build-image-arm64:
	docker buildx build \
		--platform linux/arm64 \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg GO_VERSION=$(GO_VERSION) \
		-f docker/Dockerfile.debian-bookworm \
		-t $(IMAGE) \
		--load .

export-image-amd64:
	docker buildx build \
		--platform linux/amd64 \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg GO_VERSION=$(GO_VERSION) \
		-f docker/Dockerfile.debian-bookworm \
		-t $(IMAGE) \
		--output=type=docker,dest=$(EXPORT_TAR_AMD64) .

pull-image:
	docker pull $(IMAGE)

push-image:
	docker buildx build \
		--platform $(PUSH_PLATFORMS) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg GO_VERSION=$(GO_VERSION) \
		-f docker/Dockerfile.debian-bookworm \
		-t $(IMAGE) \
		--push .

ps:
	docker compose ps -a

logs:
	docker compose logs --tail=200 dev || true

clean:
	CONTAINER_NAME=$(CONTAINER_NAME) docker compose down --remove-orphans
	-docker rm -f $(CONTAINER_NAME) >/dev/null 2>&1
