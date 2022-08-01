# Wallabag

## Run a console command in the container

```bash
docker exec -it <containerName> /var/www/wallabag/bin/console <command> --env=prod
```

## List commands

```bash
docker exec -it wallabag /var/www/wallabag/bin/console list --env=prod
```

## Get help for a command

```bash
docker exec -it wallabag /var/www/wallabag/bin/console help <command> --env=prod
```

## Initialize the database

```bash
docker exec -it wallabag /var/www/wallabag/bin/console wallabag:install --env=prod --no-interaction
```

## List users

```bash
docker exec -it wallabag /var/www/wallabag/bin/console wallabag:user:list --env=prod
```

## Create a new user

```bash
docker exec -it wallabag /var/www/wallabag/bin/console fos:user:create --env=prod
```

## Make a user super admin

```bash
docker exec -it wallabag /var/www/wallabag/bin/console fos:user:promote <user> --super --env=prod
```

## Demote and deactivate the initial wallabag user

```bash
docker exec -it wallabag /var/www/wallabag/bin/console fos:user:demote wallabag --super --env=prod
docker exec -it wallabag /var/www/wallabag/bin/console fos:user:deactivate wallabag --env=prod
```
