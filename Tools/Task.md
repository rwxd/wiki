# Task
[Task](https://taskfile.dev/#/) is a runner / built tool. 

The configuration is written in a `Taskfile.yml`

Taskfile Template
```yaml
# https://taskfile.dev  
  
version: '3'  
  
vars:  
GREETING: Hello, World!  
  
tasks:  
default:  
cmds:  
- echo "{{.GREETING}}"  
silent: true
```

## Usage
Init a Taskfile template 
`task --init`

List tasks
`task -l` or `task --list`

Use vars at global or task level
```yaml
vars:
  CONTAINER_NAME: wiki.rwxd.eu
  CURRENT_DIR:
  	sh: pwd
  SITE_DIR: "{{.CURRENT_DIR}}/site"
```

## Links
