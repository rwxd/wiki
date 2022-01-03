# Build go binaries

## Linux
```bash
GOOS=linux GOARCH=amd64 go build -v
```

## Windows
```bash
GOOS=windows GOARCH=amd64 go build -v
```

## Helpful Makefile

```makefile
PROJECT_NAME := "test-project"
PKG := "github.com/rwxd/$(PROJECT_NAME)"
PKG_LIST := $(shell go list ${PKG}/...)
GO_FILES := $(shell find . -name '*.go' | grep -v _test.go)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: build

test: ## Test go code
	@go test -race ./...

dep: ## Get the dependencies
	@go get -v -d ./...

setup: ## Install required things
	python3 -m pip install -r requirements-dev.txt
	pre-commit install

build: dep build-linux build-windows ## Build for all platforms

build-linux: dep ## Build for linux
	@mkdir -p build/
	@GOOS=linux GOARCH=amd64 go build -o build/ -v $(PKG)

build-windows: dep ## Build for windows
	@mkdir -p build/
	@GOOS=windows GOARCH=amd64 go build -v -o build/ $(PKG)

clean: ## Remove previous build
	@rm -rf build/

```
 