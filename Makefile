GOPATH:=$(PWD)
BUILD_DIR=$(GOPATH)/src/github.com/mholt/caddy/caddy

get:
	go get -d -u github.com/mholt/caddy
	go get -d -u github.com/caddyserver/builds

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

all: get linux-amd64 darwin windows-amd64 freebsd-amd64

.PHONY: get linux-amd64 darwin windows-amd64 freebsd-amd64
