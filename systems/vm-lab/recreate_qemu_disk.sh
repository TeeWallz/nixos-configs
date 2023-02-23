

# Run beforehand
```bash
DISK_IMAGE=/var/lib/libvirt/images/nixos-unstable.qcow2
SNAPSHOT_NAME=before_work
```

# List snapshot
```bash
qemu-img snapshot -l $DISK_IMAGE
```

# Create snapshot
```bash
qemu-img snapshot -c $SNAPSHOT_NAME $DISK_IMAGE
```

# Delete snapshot
```bash
qemu-img snapshot -d $SNAPSHOT_NAME  $DISK_IMAGE
```


# Apply snapshot
```bash
qemu-img snapshot -a $SNAPSHOT_NAME $DISK_IMAGE
```