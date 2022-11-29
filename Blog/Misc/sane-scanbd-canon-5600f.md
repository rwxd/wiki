# Sane & scanbd with Canon CanonScan 5600f

## Installation on a raspbian

```bash
sudo apt install sane sane-utils sanebd
```

## Configuration

Copy sane configuration to scanbd.

```bash
cp -r /etc/sane.d/* /etc/scanbd/sane.d/
```

Modify `/etc/sane.d/dll.conf` so that only `net` is uncommented in the configuration.

```bash
# genesys
net
# canon
```

Test if the scanner is detected

```bash
SANE_CONFIG_DIR=/etc/scanbd scanimage -A
```

```bash
root@scanner:/opt/insaned# SANE_CONFIG_DIR=/etc/scanbd scanimage -L
device 'genesys:libusb:001:004' is a Canon CanoScan 5600F flatbed scanner
```

### Start & enable the service

```bash
sudo systemctl start scanbd
sudo systemctl enable scanbd
```

### Edit the button configuration

`/etc/scanbd/scanbd.conf`

The `scan` action runs the `test.script` per default. The path of the script or the content can be changed.

```bash
action scan {
        filter = "^scan.*"
        numerical-trigger {
               from-value = 1
               to-value   = 0
               }
        desc   = "Scan to file"
        script = "/usr/local/bin/scan-to-share"
       }
```

At the bottom

```bash
# devices
# each device can have actions and functions, you can disable not relevant devices
include(scanner.d/canon.conf)
```

## Debugging

```bash
systemctl stop scanbd
SANE_CONFIG_DIR=/etc/scanbd scanbd -f
```

More verbose:

```bash
systemctl stop scanbd
SANE_CONFIG_DIR=/etc/scanbd scanbd -f -d7
```


## Scan script

```bash
#!/usr/bin/env bash
set -x -e -o pipefail

log_file="/var/scans/scan.log"
echo "Starting script" >> "$log_file"

resolution=300
file_ending=jpg
format=jpeg
mode=color

file_data=$(date +'%Y_%m_%d-%H_%M_%S')
filename="$file_data.$file_ending"
temp_path="/tmp/$filename"
dest_path="/var/scans/scanned/$file_data.pdf"

echo "Destination path \"$dest_path\"" >> "$log_file"
echo "Starting scan with resolution $resolution, format $format & mode $mode" >> "$log_file"

export SANE_CONFIG_DIR=/etc/scanbd
scanimage --format "$format" --resolution="$resolution" --mode "$mode" -v -p > "$temp_path"
img2pdf "$temp_path" -o "$dest_path"
rm "$temp_path"
chmod 777 "$dest_path"
```
