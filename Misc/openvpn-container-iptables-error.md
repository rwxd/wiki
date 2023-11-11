# Problems with iptables in a OpenVPN container; leaking the real IP

I was using the container "dperson/openvpn-client:latest" in combination with a deluge container.
Which has the `--net=container:vpn` option to use the same network stack as the vpn container.

By using the website https://ipleak.net/ I noticed that my real IP was leaking while testing the torrent client.
The torrent client was listed with the VPN ip and the real ip.
Using `curl ipinfo.io` showed only the VPN ip.

The host is an AlmaLinux 9.2.

In the container logs where the following lines:

```bash
> docker logs vpn | grep "ip\dtables"
tables v1.8.4 (legacy): can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.
```

IP tables version on the host and in the container:

```bash
> iptables -V
iptables v1.8.8 (nf_tables)

> docker exec vpn iptables -V
iptables v1.8.4 (legacy)
```

So the container was using the legacy iptables version. Also visible in the [Dockerfile](https://github.com/dperson/openvpn-client/blob/master/Dockerfile#L5).

The nftables_nat modules are loaded, but the legacy iptables_nat modules are not.

```bash
> lsmod | grep nf_nat
nf_nat                 57344  3 xt_nat,nft_chain_nat,xt_MASQUERADE

> lsmod | grep "^ip\w*table_nat"
```

So we can load the legacy modules with modprobe.

```bash
> modprobe iptable_nat
> modprobe ip6table_nat
```

```bash
> lsmod | grep "^ip\w*table_nat"
```

Now the legacy modules are loaded and the error message is gone.

```bash
> docker restart vpn
```

Make the modules persistent.

```bash
touch /etc/modules-load.d/iptables_nat.conf
printf "iptable_nat\nip6table_nat\n" > /etc/modules-load.d/iptables_nat.conf
```

This solution also works when podman is used instead of docker.
