GOPATH:=$(PWD)
BUILD_REPO=github.com/mholt/caddy/caddy
BUILD_TAG?=$(shell cd -- "src/$(BUILD_REPO)" && git describe --abbrev=0 --tags)
BUILD_DIR=$(GOPATH)/src/$(BUILD_REPO)

get-master:
	if [ -d "src/$(BUILD_REPO)" ]; then cd "src/$(BUILD_REPO)" && git checkout -q master; fi
	go get -d -u -- "$(BUILD_REPO)"
	go get -d -u github.com/caddyserver/builds

_get-tag:
	cd "src/$(BUILD_REPO)" && git checkout "refs/tags/$(BUILD_TAG)"

get-tag: get-master _get-tag

linux-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=linux -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy-linux-amd64"

darwin:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=darwin
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy-darwin"

windows-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=windows -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy.exe" "bin/caddy-windows-amd64.exe"

freebsd-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=freebsd -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy-freebsd-amd64"

releaseinfo:
	go version > bin/caddy-release.md
	@printf -- '\n```\n' >> bin/caddy-release.md
	find src -name .git -exec bash -c 'printf -- "$$(dirname -- "{}") " && git --git-dir="{}" rev-parse HEAD' \; >> bin/caddy-release.md
	@printf -- '```\n' >> bin/caddy-release.md

all: get-tag linux-amd64 darwin windows-amd64 freebsd-amd64 releaseinfo

.PHONY: get-master _get-tag get-tag linux-amd64 darwin windows-amd64 freebsd-amd64 releaseinfo
