## Issues

`Error: failed to create volume "immich-data": giving /mnt/media-box/immich a label: setting selinux label for /mnt/media-box/immich to "system_u:object_r:container_file_t:s0:c785,c978" as shared: lsetxattr /mnt/media-box/immich: operation not supported`

An Volume was on an sshfs mount, the type was `DirectoryOrCreate`, it must be `Directory` or else selinux labeling is tried

```yaml
volumes:
  - name: immich-data
    hostPath:
      path: /mnt/media-box/immich
      type: Directory
```
