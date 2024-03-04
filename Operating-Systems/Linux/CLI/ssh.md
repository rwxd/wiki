# SSH

## Jump host

Use another system to tunnel the traffic trough:
```bash
ssh -J other.host original.host
```

## SOCKS Proxy

```bash
ssh -D 1337 -C $USER@<target>
```
