# Wallabag

## Run a console command in the container

```bash
docker exec -it <containerName> /var/www/wallabag/bin/console <command> --env=prod
```

## Get help for a command

```bash
docker exec -it <containerName> /var/www/wallabag/bin/console help <command> --env=prod
```

## Create a new user

```bash
docker exec -it wallabag /var/www/wallabag/bin/console fos:user:create --env=prod
```
