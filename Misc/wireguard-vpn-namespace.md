# Creating a network namespace that uses wireguard vpn

We will setup a network namespace that uses a wireguard vpn.
IPv4 and IPv6 will be routed through the vpn.
But it can also be used for IPv4 only or IPv6 only.

Additionally we want to access an service in the namespace from the host.


## Create the namespace

```bash
ip netns add vpn
```

### Add a loopback interface

```bash
ip -n vpn addr add 127.0.0.1/8 dev lo
ip -n vpn addr add ::1/128 dev lo
ip -n vpn link set lo up
```

Verify the loopback interface:

```bash
ip -n vpn addr show lo
```

## Create a wireguard interface

```bash
ip link add wg0 type wireguard
ip link set wg0 netns vpn
```

### Configure the wireguard interface

With `ip netns exec vpn` we can execute commands in the namespace.

We use a `wg-quick` configuration to configure the wireguard interface.

```bash
ip netns exec vpn wg setconf wg0 <(wg-quick strip /etc/wireguard/wg0.conf)
```

### Add addresses

Addresses in the wg-quick format (Address = ...) will be stripped by `wg-quick strip`.
So they have to be added manually.

```bash
ip -n vpn address add 10.65.186.143/32 dev wg0
ip -n vpn address add fd00:dead:beef:cafe::1/128 dev wg0
```

### Bring up the wireguard interface

```bash
ip -n vpn link set wg0 up
```

### Add a default v4 and v6 route

```bash
ip -n vpn route add default dev wg0
ip -n vpn -6 route add default dev wg0
```

### Verify the wireguard interface

```bash
# show the interface
ip -n vpn addr show wg0
ip -n vpn route show

# ping cloudflare
ip netns exec vpn ping 1.1.1.1
ip netns exec vpn ping 2606:4700:4700::1111
```

## Setup resolv.conf to prevent DNS leaks in the namespace

```bash
mkdir -p /etc/netns/vpn
echo "nameserver <vpns dns server>" >> /etc/netns/vpn/resolv.conf
```

### Test DNS Server

```bash
# verify resolving
ip netns exec vpn curl -4 https://ipv4.ipleak.net/json/
ip netns exec vpn curl -6 https://ipv6.ipleak.net/json/

# show which dns server is actually used
session=$(openssl rand -hex 20)
random=$(openssl rand -hex 10)
ip netns exec vpn curl -4 -s "https://$session-$random.ipleak.net/dnsdetection/"
ip netns exec vpn curl -6 -s "https://$session-$random.ipleak.net/dnsdetection/"
```

## Create a veth to connect the namespace to the host

We will create veth interface pair to-ns-vpn in the root namespace and from-ns-vpn in the vpn namespace.

```bash
