# Podman rootless setup

## Install podman

```bash
dnf install -y podman podman-docker
```

## Enable low ports

```bash
if ! grep -q "net.ipv4.ip_unprivileged_port_start=80" /etc/sysctl.conf; then echo "net.ipv4.ip_unprivileged_port_start=80" >> /etc/sysctl.conf; fi

# Reload sysctl
sysctl --system
```
## Create user

```bash
useradd -m -s /bin/bash container
sudo -iu container
```

## Create podman socket

```bash
if ! grep -q "loginctl enable-linger" ~/.bashrc; then echo "loginctl enable-linger $(whoami)" >> ~/.bashrc; fi
if ! grep -q "$temp" ~/.bashrc; then echo "XDG_RUNTIME_DIR=/run/user/$(id -u)" >> ~/.bashrc; fi
source ~/.bashrc
```
