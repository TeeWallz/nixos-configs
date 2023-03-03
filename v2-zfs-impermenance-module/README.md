
ZFS Impermenance

# V1 Pool Setup
Source:
https://openzfs.github.io/openzfs-docs/Getting Started/NixOS/index.html#root-on-zfs
```
ZFS WEBSITE POOLS/DATASETS
Datasets:
 zpool
   nixos
     root     -> /mnt/
     home     -> /mnt/home
     var      -> 
     var/lib  -> 
     var/log  -> 
     empty    ->               (Snapshotted empty, labelled @start)
 bpool
   nixos
     root     -> /mnt/boot
```


# V2 pool setup
Datasets under rpool/safe are backed up, rpool/local arent

```
rpool
  ephemeral
    root    -> /mnt       (Snapshotted as @blank)
    nix     -> /mnt/nix
  safe
    persist -> /mnt/persist
    <!-- home    -> /mnt/home -->
  
```


# First setup that works consistently
```bash
sudo su

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4

cd /tmp
curl -o /tmp/nixos-configs.zip -L "https://github.com/TeeWallz/nixos-configs/archive/refs/heads/main.zip"
unzip /tmp/nixos-configs.zip
cd /tmp/nixos-configs-main/v2-zfs-impermenance-module/scripts
./setup_vm.sh
```

