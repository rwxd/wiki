# NFCAPD (NetFlow Capture Daemon)

## Show running captures

```bash
sudo ps -e -o command | grep nfcapd
```

## Edit configuration

Find the nfsen configuration first

```bash
sudo find / -type f -name "nfsen.conf"
```

```bash
vim /opt/etc/nfsen.conf
```

## Links
- <https://manpages.ubuntu.com/manpages/bionic/man1/nfcapd.1.html>
