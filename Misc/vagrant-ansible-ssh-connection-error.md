# SSH Connection Error when using Vagrant and Ansible

I got the following error when using Vagrant and the Ansible provisioner:
```bash
TASK [Install packages] ********************************************************
fatal: [default]: FAILED! => {"changed": false, "module_stderr": "Shared connection to 192.168.124.116 closed.\r\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 137}
```

This error occured every time I tried to provision the VM with Ansible.

With using `ansible.verbose = "vvvvv"` in the Vagrantfile I got the following output:

```bash
--- snip ---
mux_client_read_packet: read header failed: Broken pipe\r\ndebug2: Received exit status from master 137\r\nShared connection to 192.168.124.116 closed.\r\n",
--- snip ---
```

Error code 137 is issued when a process is terminated externally because of its memory consumption.

When checking the kernel logs with `journalctl -t oom_reaper` I found the following lines:

```bash
vagrant ssh
dmesg | grep oom
[ 1158.525674] Out of memory: Killed process 2428 (dnf) total-vm:479860kB, anon-rss:352668kB, file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:836kB oom_score_adj:0
[ 6304.776507] python3 invoked oom-killer: gfp_mask=0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), order=0, oom_score_adj=0
[ 6304.776529]  oom_kill_process.cold+0xb/0x10
[ 6304.776637] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[ 6304.776674] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/user.slice/user-1000.slice/session-5.scope,task=python3,pid=2879,uid=0
[ 6304.776682] Out of memory: Killed process 2879 (python3) total-vm:401128kB, anon-rss:341880kB, file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:816kB oom_score_adj:
```

It clearly shows that the process `dnf` was killed because of the memory consumption.

The default Vagrant VM has 512 MB RAM. It seems that this is not enough for the Ansible provisioning.

I increased the RAM to 2048 MB and the provisioning worked without any problems.

```ruby
config.vm.provider "libvirt" do |libv|
    libv.memory = "4096"
end
```
