# Configure apt repository updates on Proxmox 8.x.x Community Edition

## Add the Proxmox repositoy to /etc/apt/sources.list.d/pve-community.list

```bash
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-community.list
```

## Comment out the enterprise repository at /etc/apt/sources.list.d/pve-enterprise.list

```bash
sed -i 's/^deb/#deb/' /etc/apt/sources.list.d/pve-enterprise.list
```

## Change the ceph repository at /etc/apt/sources.list.d/ceph.list

```bash
sed -i 's/^deb/#deb/' /etc/apt/sources.list.d/ceph.list
echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" >> /etc/apt/sources.list.d/ceph.list
```
