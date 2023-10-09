# autorestic - High backup level CLI utility for restic.

[Documentation](https://autorestic.vercel.app/)

The commands will work with the configuration saved to `~/.autorestic.yaml` you can also specify a different config file with the `-c` flag.

## Init backend

```bash
autorestic check
```

## Backup

```bash
# all
autorestic backup --all

# specific locations
autorestic backup --locations "<location1>,<location2>"
```

## Show stats for a backend

```bash
autorestic exec -vb <backend> stats
```

## Show snapshots for a backend

```bash
autorestic exec -vb <backend> snapshots
```

## Check a backend for errors

```bash
autorestic exec -vb <backend> check
```

## Mount repository on backend

```bash
mkdir -p /mnt/restic
autorestic exec -vb <backend> mount -- /mnt/restic
```
