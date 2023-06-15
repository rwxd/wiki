# Use systemd files with rootless podman-compose

Currently (as of 6/15/2023), podman-compose must be manually installed to use version 1.0.7 (check with podman-compose -v), [because pods are not used by default] (https://github.com/containers/podman-compose/issues/307#issuecomment-1517822926).

```bash
pip3 install git+https://github.com/containers/podman-compose.git
```

## Setup

Add the rootless podman user to the systemd-journal group to watch logs.

```bash
usermod -aG systemd-journal podman
```

Create the systemd podman-compose unit with root permissions

```bash
sudo podman-compose systemd --action create-unit
sudo systemctl daemon-reload
```

Change to the directory where your podman-compose file resides.

Register the project

```bash
podman-compose systemd --action register

# or with a different file name than podman-compose.yaml
podman-compose -f docker-compose.yaml systemd --action register
```

Enable and start the systemd service

```bash
systemctl --user enable --now 'podman-compose@project-name'
```

Stop & Start

```bash
systemctl --user stop 'podman-compose@project-name'
systemctl --user start 'podman-compose@project-name'
```

## Troubleshooting

When the  systemd unit is create you can use

```bash
podman pod ls

podman pod inspect pod_project-name

systemctl --user status -l podman-compose@project-name

journalctl --user -xu podman-compose@project-name
```
