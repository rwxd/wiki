# Docker commands

## Remove things

### All Containers

```bash
docker rm -f $(docker ps -aq)
```

### All Images

```bash
docker rmi $(docker images -q)
```
