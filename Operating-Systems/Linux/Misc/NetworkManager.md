# NetworkManager

## WLAN

### Autoconnect

```bash
nmcli connection modify <name> connection.autoconnect yes
```

```bash
nmcli connection modify <name> 802-11-wireless-security.psk <psk>
```

```bash
nmcli connection up <name>
```
