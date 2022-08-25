# Docker commands

## Stop things

### Stop all containers

```bash
docker stop $(docker ps -aq)
```

## Remove things

### Remove all containers

```bash
docker rm $(docker ps -aq)
```

### Remove & stop all containers

```bash
docker rm -f $(docker ps -aq)
```

### All Images

```bash
docker rmi $(docker images -q)
```

### Start docker daemon in debug mode

```bash
sudo dockerd --debug
```
