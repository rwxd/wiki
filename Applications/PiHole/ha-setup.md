# PiHole HA Setup

## What are we trying to achieve?

We want to have two PiHole instances that share the same ip address.
If one of the instances fails the other one will take over the ip address.

They will also share the same gravity database so you only have to update the gravity database on one of the instances.

## Why do we want this?

If you have a PiHole instance running on a Raspberry Pi and it fails you will have to wait until you can fix it.
This means manually changing the dns server on all your devices or trying to change the dhcp server to point to a different dns server.
With this setup you will have a backup PiHole instance that will take over the ip address of the primary instance when it fails.


## Requirements

- Two PiHole instances
- A ip address that is not used by any other device on your network
- Both PiHole instances must be on the same network
- Both PiHole instances must have the same version, check with `pihole -v`, update with `pihole -up`
- They may need to be reconfigured with `pihole -r` to get them to work properly

## Setup keepalive

### Install required packages

```bash
sudo apt install keepalived
```

### Configure keepalived

Script to check if local instance is running

```bash
cat << EOF > /usr/local/bin/check-local-pihole
#!/bin/sh

RUNNING=$(ps -aux | grep pihole-FTL | grep -v grep)
exit $?
EOF

chmod +x /usr/local/bin/check-local-pihole
```

#### Configure keepalived on the primary instance

```python
cat << EOF > /etc/keepalived/keepalived.conf
vrrp_script chk_local_pihole {
    script "/usr/local/bin/check-local-pihole" # (1)!
    interval 5
    weight -100
}

global_defs {
  router_id pihole-01 # (2)!
  script_user root
  enable_script_security
}

vrrp_instance PIHOLE {
  state MASTER # (3)!
  interface eth0 # (4)!
  virtual_router_id 20 # (5)!
  priority 150
  advert_int 1
  unicast_src_ip 192.168.3.21 # (6)!
  unicast_peer {
    192.168.3.22 # (7)!
  }

  authentication {
    auth_type PASS
    auth_pass piholedns # (8)!
  }

  virtual_ipaddress {
    192.168.3.20/23 # (9)!
  }

  track_script {
    chk_local_pihole
  }
}
EOF
```

1. Path to the script that checks if the local instance is running
2. Name of the router
3. State of the instance, MASTER or BACKUP
4. Interface to use
5. virtual_router_id, must be the same on both instances
6. unicast_src_ip, ip address of the local instance
7. unicast_peer, ip address of the remote instance
8. auth_pass, must be the same on both instances
9. virtual_ipaddress, ip address that will be used by the clients and shared between the two instances

##### Configure keepalived on the secondary instance

```python
cat << EOF > /etc/keepalived/keepalived.conf
vrrp_script chk_pihole {
  script "/usr/local/bin/check-local-pihole"
  interval 1
  weight -100
}

global_defs {
  router_id pihole-02
  script_user root
  enable_script_security
}

vrrp_instance PIHOLE {
  state BACKUP
  interface eth0
  virtual_router_id 20
  priority 140
  advert_int 1
  unicast_src_ip 192.168.3.22
  unicast_peer {
    192.168.3.21
  }

  authentication {
    auth_type PASS
    auth_pass piholedns
  }

  virtual_ipaddress {
    192.168.3.20/23
  }

  track_script {
    chk_local_pihole
  }
}
EOF
```

### Start keepalived

Run on both instances

```bash
systemctl enable --now keepalived.service
```

### Test keepalived

1. Check if the pihole portal is reachable through the virtual ip address
2. Check if the virtual ip address is assigned to the primary instance by watching the output of `ip a` on both instances
    or looking at the pihole dashboard in the top right corner
3. Restart the pihole service on the primary instance and check if the virtual ip address is assigned to the secondary instance
4. Check if the primary instance will take over the virtual ip address when it is restarted

## Sync gravity database

### Install required packages

```bash
apt update && apt install sqlite3 sudo git cron rsync ssh
```

### Install gravity sync script

We will use [gravity-sync](https://github.com/vmstan/gravity-sync) to sync the gravity database between the two instances.

Install gravity-sync on both instances and follow the instructions.

```bash
curl -sSL https://raw.githubusercontent.com/vmstan/gs-install/main/gs-install.sh | bash
```

> You can always reset the configuration with `gravity-sync config`

### Push gravity database to secondary instance

Run the following command on the primary instance to push the gravity database to the secondary instance.

```bash
gravity-sync push
```

### Automate gravity database sync

Run the following command on both instances to create a systemd timer that will sync the gravity database every 5 minutes.

```bash
gravity-sync automate
```

You can check the status of the timer with `systemctl status gravity-sync.timer`.  
And you can check the logs with `journalctl -u gravity-sync.service`.

With `gravity-sync automate hour` the timer will sync the gravity database every hour.
