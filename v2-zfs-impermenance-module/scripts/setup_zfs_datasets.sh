
# ZFS WEBSITE POOLS/DATASETS
# Datasets:
#  zpool
#    nixos
#      root     -> /mnt/
#      home     -> /mnt/home
#      var      -> 
#      var/lib  -> 
#      var/log  -> 
#      empty    ->               (Snapshotted empty, labelled @start)
#  bpool
#    nixos
#      root     -> /mnt/boot

# Define ZFS datasets
dataset_boot="bpool/nixos"
dataset_boot_root="${dataset_boot}/root"

datasets_base="rpool/nixos"
dataset_local="${datasets_base}/local"
dataset_nix="${dataset_local}/nix"
dataset_root="${dataset_local}/root"
dataset_persist="${datasets_base}/persist"
# dataset_home="{$dataset_persist}/home"

echo $dataset_boot
echo $dataset_boot_root
echo $datasets_base
echo $dataset_local
echo $dataset_nix
echo $dataset_root
echo $dataset_persist


# Create base dataset with encryption
zfs create \
    -o canmount=off \
    -o mountpoint=none \
    -o encryption=on \
    -o keylocation=prompt \
    -o keyformat=passphrase \
    $datasets_base

# Create our datasets
zfs create -o mountpoint=legacy "${dataset_persist}"
zfs create -p -o mountpoint=legacy "${dataset_nix}"
zfs create -p -o mountpoint=legacy "${dataset_root}"
# Snapshot root before anything is created so that it can be wiped on boot
zfs snapshot rpool/local/root@blank

# Create boot datasets
zfs create -o mountpoint=none "${dataset_boot}"
zfs create -o mountpoint=legacy "${dataset_boot_root}"

# Mount datasets here so we can install bootloader and Nixos
mkdir /mnt/boot
mkdir /mnt/nix

mount -t zfs "${dataset_root}" /mnt/
mount -t zfs "${dataset_boot_root}" /mnt/boot
mount -t zfs "${dataset_nix}" /mnt/nix


# Create var datasets
# zfs create -o mountpoint=legacy  rpool/nixos/var
# zfs create -o mountpoint=legacy rpool/nixos/var/lib
# zfs create -o mountpoint=legacy rpool/nixos/var/log
