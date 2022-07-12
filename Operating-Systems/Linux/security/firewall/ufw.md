# UFW

## Get status

```bash
ufw status verbose
```

## Rules

### Ports

```bash
ufw allow 22/tcp
````

```bash
ufw deny 80/tcp
````

### Remove Ports

```bash
ufw delete allow 22/tcp
```

## Block all incoming traffic

```bash
ufw default deny incoming
```


