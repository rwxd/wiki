# SSH into Containerlab devices

## SSH Config

`$HOME/.ssh/config`

```bash
host clab-*
	StrictHostKeyChecking no
	UserKnownHostsFile /dev/null
```
