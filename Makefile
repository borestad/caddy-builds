GOPATH:=$(PWD)
BUILD_DIR=$(GOPATH)/src/github.com/mholt/caddy/caddy
GOVERSION=$(shell go version | awk '{print $$3}')

get:
	go get -d -u github.com/mholt/caddy
	go get -d -u github.com/caddyserver/builds

linux-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=linux -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy-$(GOVERSION)-linux-amd64"

darwin:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=darwin
	mv -- "$(BUILD_DIR)/caddy" "bin/caddy-$(GOVERSION)-darwin"

all: get linux-amd64 darwin

.PHONY: get linux-amd64 darwin
