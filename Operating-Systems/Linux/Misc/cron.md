# Cron

## Cron with error mails

[Install chronic](https://command-not-found.com/chronic)

```bash
apt install moreutils
```

/etc/cron.d/01-example-cron

```bash
#!/usr/bin/env bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin/usr/local/bin
MAILTO=root,my-mail@example.org

0 0 * * * root chronic /usr/local/bin/backup
```
