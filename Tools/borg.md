# Borg

## Delete directory from all backups

Dry-Run

```bash
borg recreate <archive> --dry-run --list --verbose --exclude <path>
```

Delete

```bash
borg recreate <archive> --list --verbose --exclude <path>
```
