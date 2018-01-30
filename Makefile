GOPATH:=$(PWD)
BUILD_DIR:=$(GOPATH)/src/github.com/mholt/caddy/caddy

clean:
	rm -f bin/*

get:
	go get -d -u github.com/mholt/caddy
	go get -d -u github.com/caddyserver/builds

linux-amd64: bin/caddy-linux-amd64
bin/caddy-linux-amd64:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=linux -goarch=amd64
	mv -- "$(BUILD_DIR)/caddy" bin/caddy-linux-amd64

darwin: bin/caddy-darwin
bin/caddy-darwin:
	cd -- "$(BUILD_DIR)" && go run build.go -goos=darwin
	mv -- "$(BUILD_DIR)/caddy" bin/caddy-darwin

all: clean get linux-amd64 darwin

.PHONY: clean get linux-amd64 darwin
