# Podman Quadlets

## Pre-requisites

When using rootless podman a directory under the user's home directory must be created for the quadlet files.

```bash
mkdir -p ~/.config/containers/systemd
```

## Container

A container quadlet file must end with `.container` in the `~/.config/containers/systemd` directory.

Example quadlet file to run a deluge container (`deluge.container` file):

```systemd
[Install]
WantedBy=default.target

[Unit]
After=mullvadvpn.service

[Container]
Image=docker.io/linuxserver/deluge:latest
Volume=/opt/container/deluge/downloads/:/downloads
Volume=/opt/container/deluge/config/:/cofnig

[Service]
# Restart service when sleep finishes
Restart=always
# Extend Timeout to allow time to pull the image
TimeoutStartSec=900
```

All the options for the quadlet file can be found in the [podman documentation](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#container-units-container).

### Start

```bash
systemctl --user daemon-reload
systemctl --user start deluge
```

### Logs

```bash
podman logs systemd-deluge

journactl -f | grep deluge
```

## Pods
