# Problems with a podman / docker container that uses an volume on a sshfs / fuse mount

```bash
PermissionError: [Errno 13] Permission denied: '/config/deluged.log'
```

Uncomment `user_allow_other` in `/etc/fuse.conf and ensure in `/etc/fstab` that the sshfs mount has the `allow_other` flag set.
