# sendmail process at high cpu usage
I had it sometimes under Alma Linux that after a cronjob fails the sendmail process has a high cpu usage
and runs continuously.

```bash
dnf install esmtp-local-delivery
```
