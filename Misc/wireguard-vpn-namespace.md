# Creating a network namespace that uses wireguard vpn

We will setup a network namespace that uses a wireguard vpn.
IPv4 and IPv6 will be routed through the vpn.
But it can also be used for IPv4 only or IPv6 only.

Additionally we want to access an service in the namespace from the host.

## Bash Script

```bash
#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="vpn"
WG_INTERFACE="wg0"
WG_CONFIG="/etc/wireguard/wg0.conf"
WG_IPV4="10.65.186.143/32"
WG_IPV6="fc00:bbbb:bbbb:bb01::2:ba8e/128"
VETH_TO_NS_IP="10.0.187.4/31"
VETH_TO_NS_IPV6="fd00:0:187::4/127"
VETH_FROM_NS_IP="10.0.187.5/31"
VETH_FROM_NS_IPV6="fd00:0:187::5/127"
NAMESERVER="10.64.0.1"
PODMAN_CONTAINER_PORT="8112"
IPTABLES_NAT_PORT="8112"
HOME_SUBNET="192.168.2.0/23"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Process command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            VERBOSE=true
            set -x
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Create network namespace
if ! ip netns list | grep -q "$NAMESPACE"; then
    log "Creating network namespace: $NAMESPACE"
    ip netns add "$NAMESPACE"
    ip -n "$NAMESPACE" addr add 127.0.0.1/8 dev lo
    ip -n "$NAMESPACE" addr add ::1/128 dev lo
    ip -n "$NAMESPACE" link set lo up
else
    log "Network namespace $NAMESPACE already exists."
fi

# Create WireGuard interface
if ! ip -n "$NAMESPACE" link show "$WG_INTERFACE" &> /dev/null; then
    log "Creating WireGuard interface: $WG_INTERFACE"
    ip link add "$WG_INTERFACE" type wireguard
    ip link set "$WG_INTERFACE" netns "$NAMESPACE"
    ip netns exec "$NAMESPACE" wg setconf "$WG_INTERFACE" <(wg-quick strip "$WG_CONFIG")
    ip -n "$NAMESPACE" address add "$WG_IPV4" dev "$WG_INTERFACE"
    ip -n "$NAMESPACE" address add "$WG_IPV6" dev "$WG_INTERFACE"
    ip -n "$NAMESPACE" link set "$WG_INTERFACE" up
else
    log "WireGuard interface $WG_INTERFACE already exists."
fi

# Add default route for WireGuard interface if it does not exist
if ! ip -n "$NAMESPACE" route show | grep -q "default dev $WG_INTERFACE"; then
    log "Adding default route for WireGuard interface"
    ip -n "$NAMESPACE" route add default dev "$WG_INTERFACE"
fi

if ! ip -n "$NAMESPACE" -6 route show | grep -q "default dev $WG_INTERFACE"; then
    log "Adding IPv6 default route for WireGuard interface"
    ip -n "$NAMESPACE" -6 route add default dev "$WG_INTERFACE"
fi


# Configure nameserver
log "Configuring nameserver: $NAMESERVER"
echo "nameserver $NAMESERVER" > "/etc/netns/$NAMESPACE/resolv.conf"

# Create veth pair
if ! ip link show "to-ns-$NAMESPACE" &> /dev/null; then
    log "Creating veth pair: to-ns-$NAMESPACE and from-ns-$NAMESPACE"
    ip link add "to-ns-$NAMESPACE" type veth peer name "from-ns-$NAMESPACE" netns "$NAMESPACE"
    ip address add "$VETH_TO_NS_IP" dev "to-ns-$NAMESPACE"
    ip address add "$VETH_TO_NS_IPV6" dev "to-ns-$NAMESPACE"
    ip link set "to-ns-$NAMESPACE" up
    ip -n "$NAMESPACE" address add "$VETH_FROM_NS_IP" dev "from-ns-$NAMESPACE"
    ip -n "$NAMESPACE" address add "$VETH_FROM_NS_IPV6" dev "from-ns-$NAMESPACE"
    ip -n "$NAMESPACE" link set "from-ns-$NAMESPACE" up
else
    log "Veth pair to-ns-$NAMESPACE and from-ns-$NAMESPACE already exists."
fi

# Add route to home network
if ! ip -n "$NAMESPACE" route show | grep -q "$HOME_SUBNET"; then
   log "Adding route to home subnet"
   IFS='/' read -r IP _ <<< "$VETH_TO_NS_IP"
   ip -n "$NAMESPACE" route add "$HOME_SUBNET" via "$IP"
fi

# Enable IP forwarding in the host
log "Enabling IP forwarding in the host"
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

log "Setting up port forwarding from the host to the Podman container"

# Extract only the IP address from the CIDR notation
IFS='/' read -r IP _ <<< "$VETH_FROM_NS_IP"
iptables-nft -t nat -I PREROUTING -p tcp --dport "$IPTABLES_NAT_PORT" -j DNAT --to-destination "$IP:$PODMAN_CONTAINER_PORT"
iptables-nft -I FORWARD -d "$IP" -p tcp --dport "$PODMAN_CONTAINER_PORT" -j ACCEPT

IFS='/' read -r IP6 _ <<< "$VETH_FROM_NS_IPV6"
ip6tables-nft -t nat -I PREROUTING -p tcp --dport "$IPTABLES_NAT_PORT" -j DNAT --to-destination "$IP6:$PODMAN_CONTAINER_PORT"
ip6tables-nft -I FORWARD -d "$IP6" -p tcp --dport "$PODMAN_CONTAINER_PORT" -j ACCEPT
```

## Systemd Unit

Put into `/etc/systemd/system/ns-vpn-setup.service`

```ini
[Unit]
Description=service to setup vpn namespace
After=network-online.target nss-lookup.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ns-vpn-setup
RemainAfterExit=true
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

### Run the service

```bash
systemctl daemon-reload
systemctl start ns-vpn-setup
```

## Tests

### Verify the wireguard interface

```bash
# show the interface
ip -n vpn addr show wg0
ip -n vpn route show

# ping cloudflare
ip netns exec vpn ping 1.1.1.1
ip netns exec vpn ping 2606:4700:4700::1111
```

### Test the connection between the namespaces:

```bash
ping -c 1 10.0.187.5
ping -c 1 fd00:0:187::5

ip netns exec vpn ping -c 1 10.0.187.4
ip netns exec vpn ping -c 1 fd00:0:187::4
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

### Example Podman Pod

Quadlet file in `/etc/containers/systemd/deluge.kube`

Notice the `After` and `Network` directives.

```ini
[Install]
WantedBy=default.target

[Unit]
After=ns-vpn-setup.service

[Kube]
Yaml=/opt/container/deluge/deluge.kube.yaml
Network=ns:/var/run/netns/vpn

[Service]
# Restart service when sleep finishes
Restart=always
# Extend Timeout to allow time to pull the image
TimeoutStartSec=900
```
