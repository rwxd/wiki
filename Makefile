PROJECT_NAME := "wiki"
CURRENT_DIR := $(shell pwd)
SITE_DIR := "$pwd/site"
CONTAINER := ghcr.io/rwxd/wiki-container:main

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

serve: ## Serve blog with a container on port 8000
	docker run --rm -p 8000:8000 -v $(CURRENT_DIR):/src $(CONTAINER) mkdocs serve

build: ## Build blog pages
	mkdir -p $(SITE_DIR)
	docker run --rm -v $(CURRENT_DIR):/src $(CONTAINER) bash -c "mkdocs build"
	ls -la
