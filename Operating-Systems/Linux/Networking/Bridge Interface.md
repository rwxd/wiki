# Create a bridge interface
## With iproute2
Create a new bridge
`ip link add name bridge_name type bridge`

Set interface to state up
`ip link set bridge_name up`

Add an interface to the bridge (state of the interface must be up)
`ip link set eth0 master bridge_name`

Verify bridge
`bridge link`

Remove interace from a bridge
`ip link set eth0 nomaster`

## Internet settings

Edit file `/etc/systemd/network/mybridge.network`
```bash
[Match]
Name=br0

[Network]
DHCP=ipv4
```

Enable, start and reload systemd-networkd
```bash
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd
sudo systemctl reload systemd-networkd
```
