# firewalld

## Zones

### List Zones

```bash
firewall-cmd --get-active-zones
```

## Rules

### Ports

```bash
firewall-cmd --permanent --zone=public --add-port=25565/tcp --add-port=19132/udp
```

Port Range

```bash
firewall-cmd --permanent --zone=public --add-port=40000-40030/udp
```

### Remove Ports

```bash
firewall-cmd --permanent --zone=public --remove-port=25565/tcp --remove-port=19132/udp
```

Port Range

```bash
firewall-cmd --permanent --zone=public --remove-port=40000-40030/udp
```

