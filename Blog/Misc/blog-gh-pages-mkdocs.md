# How to create a blog with GitHub Pages and MkDocs

<div align="center">

```plantuml
!theme amiga
actor User
node GitHub
component actions as "GitHub Actions"
artifact html as "HTML files"
node pages as "GitHub Pages"

User -right-> GitHub: push markdown files
GitHub -right-> actions: starts workflow
actions -down-> html: renders
pages -right-> html: serve files
User -down-> pages: visits website
```

</div>

## Dockerfile

Create the Containerfile at `Dockerfile` or `Containerfile`.

```Dockerfile
FROM docker.io/ubuntu:focal

RUN : \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/api/lists*

WORKDIR /src

COPY requirements.txt .
ENV PATH = /venv/bin:$PATH

RUN : \
    && python3 -m venv /venv \
    && python3 -m pip --no-cache-dir install -r requirements.txt

COPY . .

WORKDIR /src/blog
```

## Taskfile

To store some reoccuring tasks we use a Taskfile.
To install [Task](https://taskfile.dev/#/) use this [link](https://taskfile.dev/#/installation)
or just use `sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin`

Create the `Taskfile.yml`.

```yaml
# https://taskfile.dev

version: "3"

vars:
  CONTAINER_NAME: blog.rwxd.eu
  CURRENT_DIR:
    sh: pwd
  SITE_DIR: "{{.CURRENT_DIR}}/docs/site"

tasks:
  default:
    cmds:
      - task -l
    silent: true

  setup:
    desc: Setup requirements
    cmds:
      - python3 -m pip install -r requirements.txt -q
      - pre-commit install
    silent: true

  image:
    desc: builds container image with name blog.rwxd.eu
    cmds:
      - podman build -t {{.CONTAINER_NAME}} -f ./Containerfile
    silent: true

  serve:
    desc: Serve blog with a container
    vars:
      PORT: 8000
      MOUNT: "{{.CURRENT_DIR}}/src"
    cmds:
      - task: image
      - podman run --rm -p {{.PORT}}:8000 -v ./:/src {{.CONTAINER_NAME}} mkdocs serve
    silent: true

  serve-local:
    desc: Serve blog local
    dir: ./blog
    cmds:
      - mkdocs serve
    silent: true

  build:
    desc: Build blog pages
    cmds:
      - task: image
      - mkdir -p {{.SITE_DIR}}
      - podman run --rm -v {{.SITE_DIR}}:/src/blog/site {{.CONTAINER_NAME}} sh -c "mkdocs build"
```
