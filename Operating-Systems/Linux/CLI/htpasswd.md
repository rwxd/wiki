# htpasswd

## Hash BCrypt with input

```bash
htpasswd -B -n username
```

## Run with a container

```bash
docker run --rm -it httpd:latest htpasswd -B -n username
```
