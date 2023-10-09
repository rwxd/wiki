# Passtrough a hard drive from the Proxmox host to a VM

## Find the hard drive & copy the UUID

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
```

## Find the vm id

```bash
qm list
```

## Passtrough the hard drive as scsi

```bash
qm set $vm_id -scsi2 /dev/disk/by-uuid/$disk_uuid
```

## Restart the vm

```bash
qm reboot $vm_id
```

## In case it should be removed

```bash
qm unlink $vm_id --idlist scsi2
```
