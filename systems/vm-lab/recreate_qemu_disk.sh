

# Run beforehand
```bash
DISK_IMAGE=/var/lib/libvirt/images/nixos-unstable.qcow2
BACKUP_DISK_IMAGE="${DISK_IMAGE}.bak"
```

# Backup
sudo cp $DISK_IMAGE $BACKUP_DISK_IMAGE # Backup

# Restore
sudo cp $BACKUP_DISK_IMAGE $DISK_IMAGE # Clear