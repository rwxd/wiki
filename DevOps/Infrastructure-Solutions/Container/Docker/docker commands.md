# Docker commands

## Remove things

### All Containers

```bash
docker rm -rf $(docker ps -aq)
```

### All Images

```bash
docker rmi $(docker images -q)
```
