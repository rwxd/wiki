# Cisco IOS ACL

## Resequence Entries

### Before

```bash
Extended IP access list TEST
	2 permit ip host 10.10.10.1 host 10.10.10.2
	3 permit ip host 10.10.10.3 host 10.10.10.4
```

### Command

```bash
ip access-list resequence TEST 10 10
```

### After

```bash
Extended IP access list TEST
	10 permit ip host 10.10.10.1 host 10.10.10.2
	20 permit ip host 10.10.10.3 host 10.10.10.4
```
