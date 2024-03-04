# K3s on Raspberry

## Errors

### Failed to find memory cgroup, you may need to add...

[Solution](https://github.com/k3s-io/k3s/issues/2067#issuecomment-801710748)

```bash
sudo vim /boot/firmware/cmdline.txt
```

Add `cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1` into end of the file.

