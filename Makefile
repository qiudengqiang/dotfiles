.PHONY: macos macos-dry-run doctor dev shell bootstrap smoke build-image pull-image ps logs clean

macos:
	./macos/bootstrap.sh

macos-dry-run:
	./macos/bootstrap.sh --dry-run

doctor:
	./macos/doctor.sh

dev: shell

shell:
	@set -e; \
	if docker ps --filter "name=^/dotfile-dev$$" --format '{{.Names}}' | grep -q '^dotfile-dev$$'; then \
	  echo "[INFO] attaching to running container: dotfile-dev"; \
	  docker exec -it dotfile-dev zsh -l; \
	else \
	  echo "[INFO] no running container, creating: dotfile-dev"; \
	  docker compose up -d dev; \
	  docker exec -it dotfile-dev zsh -l; \
	fi

bootstrap:
	docker compose run --rm dev bootstrap

smoke:
	docker compose run --rm dev bash -lc 'set -e; nvim --version | head -n1; node --version; rg --version | head -n1; fd --version; fzf --version; prettier --version; black --version; stylua --version; dlv version | head -n1'

build-image:
	docker compose build --pull --no-cache dev

pull-image:
	docker pull vinoqiu/terminal-env:stable

push-image:
	docker push vinoqiu/terminal-env:stable

ps:
	docker compose ps -a

logs:
	docker compose logs --tail=200 dev || true

clean:
	docker compose down --remove-orphans
	-docker rm -f dotfile-dev >/dev/null 2>&1
