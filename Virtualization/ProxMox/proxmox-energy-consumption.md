# Reduce energy consumption of Proxmox

## Powertop

[Powertop](https://wiki.archlinux.org/title/powertop) is a tool to diagnose issues with power consumption and power management.  
It can also be used to tune power management settings.

### Install powertop

```bash
apt install powertop
```

### Run powertop calibration

Calibration will toggle various functions on and off to determine the best settings for your system.
So it is best to run this when the system is idle.

```bash
powertop --calibrate
```

### Run powertop to see recommendations

With <TAB> you can switch between the different tabs.

```bash
powertop
```

### Auto tune power management settings (not reboot persistent)

```bash
powertop --auto-tune
```

### Systemd service to auto tune power management settings (reboot persistent)

```bash
cat << EOF > /etc/systemd/system/powertop.service
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now powertop.service
```
