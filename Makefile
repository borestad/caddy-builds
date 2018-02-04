GOPATH:=$(PWD)
BUILD_REPO=github.com/mholt/caddy/caddy
BUILD_DIR=$(GOPATH)/src/$(BUILD_REPO)
BUILD_TAG=$(shell cd -- "src/$(BUILD_REPO)" && git describe --tags)
RELEASE_TAG?=$(shell cd -- "src/$(BUILD_REPO)" && git describe --abbrev=0 --tags)

get-master:
	if [ -d "src/$(BUILD_REPO)" ]; then cd "src/$(BUILD_REPO)" && git checkout -q master; fi
	go get -d -u -- "$(BUILD_REPO)"
	go get -d -u github.com/caddyserver/builds

get-tag: get-master
	cd "src/$(BUILD_REPO)" && git checkout "refs/tags/$(RELEASE_TAG)"

linux-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=linux -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy_$(BUILD_TAG)_linux_amd64"

darwin-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=darwin -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy_$(BUILD_TAG)_darwin_amd64"

windows-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=windows -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy.exe" "bin/caddy_$(BUILD_TAG)_windows_amd64.exe"

freebsd-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=freebsd -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy_$(BUILD_TAG)_freebsd_amd64"

releaseinfo:
	go version > "bin/caddy_$(BUILD_TAG)_release.md"
	@printf -- '\n```\n' >> "bin/caddy_$(BUILD_TAG)_release.md"
	find src -name .git -exec bash -c 'printf -- "$$(dirname -- "{}") " && git --git-dir="{}" rev-parse HEAD' \; >> "bin/caddy_$(BUILD_TAG)_release.md"
	@printf -- '```\n' >> "bin/caddy_$(BUILD_TAG)_release.md"

master: get-master linux-amd64 darwin-amd64 windows-amd64 freebsd-amd64 releaseinfo
tag: get-tag linux-amd64 darwin-amd64 windows-amd64 freebsd-amd64 releaseinfo

.PHONY: get-master get-tag linux-amd64 darwin windows-amd64 freebsd-amd64 releaseinfo master tag
