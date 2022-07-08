# SELinux

## Commands

See SELinux booleans

```bash
getsebool -a
```

Get messages since 14:05

```bash
journalctl -t setroubleshoot --since=14:05
```

### Inspection

Inspect a AVC message

```bash
sealert -l [message_ID]
```

## Flags

```bash
chcon
restorecron
```
