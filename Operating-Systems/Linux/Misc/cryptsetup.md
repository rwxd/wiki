# Cryptsetup

```bash
# format the disk with the luks structure
cryptsetup luksFormat /dev/sda4

# open the encrypted partition and map it to /dev/mapper/cryptroot
cryptsetup luksOpen /dev/sda4 cryptroot

# format as usual
mkfs.ext4 -L nixos /dev/mapper/cryptroot
```
