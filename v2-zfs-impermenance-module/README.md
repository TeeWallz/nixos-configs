
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
export GITHUB_ROOT_DIR="https://raw.githubusercontent.com/TeeWallz/nixos-configs/main/v2-zfs-impermenance-module"
export SETUP_URL="${GITHUB_ROOT_DIR}/setup/setup_vm.sh"
export NIX_CONFIG_URL="${GITHUB_ROOT_DIR}/configuration.nix"


curl -o /tmp/setup_vm.sh -L "${GITHUB_ROOT_DIR}/scripts/setup_vm.sh"
curl -o /tmp/setup_disk_and_pool.sh -L "${GITHUB_ROOT_DIR}/scripts/setup_disk_and_pool.sh"
curl -o /tmp/setup_zfs_datasets.sh -L "${GITHUB_ROOT_DIR}/scripts/setup_zfs_datasets.sh"
curl -o /tmp/format_boot.sh -L "${GITHUB_ROOT_DIR}/scripts/format_boot.sh"
curl -o /tmp/setup_nixos_configuration.sh -L "${GITHUB_ROOT_DIR}/scripts/setup_nixos_configuration.sh"


# curl -o /tmp/setup_vm.sh -L ${SETUP_URL}
chmod +x /tmp/setup_vm.sh
chmod +x /tmp/setup_disk_and_pool.sh 
chmod +x /tmp/setup_zfs_datasets.sh
chmod +x /tmp/format_boot.sh
chmod +x /tmp/setup_nixos_configuration.sh

/tmp/setup_vm.sh
```

