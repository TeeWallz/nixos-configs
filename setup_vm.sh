#!/usr/bin/env bash

set –e

# STEP 1 - SET UP PARTITITONS
# GOAL:
#   PARTITION 1: EFI            (1MiB - 1GiB)
#   PARTITION 2: ZFS BOOT POOL  (1GiB - 4GiB)
#   PARTITION 3: DATA ROOT      (Fill)
#   PARTITION 4: LINUX SWAP     (?)
#   PARTITION 5: BIOS BOOT?     (?)


export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4

for i in ${DISK}; do

    # wipe flash-based storage device to improve
    # performance.
    # ALL DATA WILL BE LOST
    # blkdiscard -f $i

    sgdisk --zap-all $i

    # PART1 - EFI system partition
    sgdisk -n1:1M:+1G -t1:EF00 $i

    # PART2 - ZFS Boot Pool - Solaris Boot Type
    sgdisk -n2:0:+4G -t2:BE00 $i

    # PART4 - linux swap
    sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200 $i

    # PART3 - ZPOOL
    if test -z $INST_PARTSIZE_RPOOL; then
        sgdisk -n3:0:0   -t3:BF00 $i
    else
        sgdisk -n3:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 $i
    fi

    # PART5 - BIOS BOOT
    sgdisk -a1 -n5:24K:+1000K -t5:EF02 $i

    # Wait for all disk tasks to complete
    sync && udevadm settle && sleep 3

    # Activate swap - TODO - Why cryptswap open?
    cryptsetup open --type plain --key-file /dev/random $i-part4 ${i##*/}-part4
    mkswap /dev/mapper/${i##*/}-part4
    swapon /dev/mapper/${i##*/}-part4
done

# Create ZFS Boot pool
zpool create \
    -o compatibility=grub2 \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/boot \
    -R /mnt \
    bpool \
    $(for i in ${DISK}; do
       printf "$i-part2 ";
      done)

# Create ZFS Root pool
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    rpool \
   $(for i in ${DISK}; do
      printf "$i-part3 ";
     done)

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





# Create nixos dataset on rpool/nixos
zfs create \
    -o canmount=off \
    -o mountpoint=none \
    -o encryption=on \
    -o keylocation=prompt \
    -o keyformat=passphrase \
    rpool/nixos

# Create and mount root dataset
zfs create -o mountpoint=legacy     rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/

# Create and mount home
zfs create -o mountpoint=legacy rpool/nixos/home
mkdir /mnt/home
mount -t zfs  rpool/nixos/home /mnt/home

# Create var datasets
zfs create -o mountpoint=legacy  rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/log

# Create boot datasets
zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root
mkdir /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot

zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start

for i in ${DISK}; do
 mkfs.vfat -n EFI ${i}-part1
 mkdir -p /mnt/boot/efis/${i##*/}-part1
 mount -t vfat ${i}-part1 /mnt/boot/efis/${i##*/}-part1
done

mkdir -p /mnt/etc/nixos/
curl -o /mnt/etc/nixos/configuration.nix -L \
https://github.com/openzfs/openzfs-docs/raw/master/docs/Getting%20Started/NixOS/Root%20on%20ZFS/configuration.nix


for i in $DISK; do
    sed -i \
    "s|PLACEHOLDER_FOR_DEV_NODE_PATH|\"${i%/*}/\"|" \
    /mnt/etc/nixos/configuration.nix
    break
done

diskNames=""
for i in $DISK; do
    diskNames="$diskNames \"${i##*/}\""
done
tee -a /mnt/etc/nixos/machine.nix <<EOF
{
    bootDevices = [ $diskNames ];
}
EOF

rootPwd=$(mkpasswd -m SHA-512 -s)

sed -i \
"s|PLACEHOLDER_FOR_ROOT_PWD_HASH|\""${rootPwd}"\"|" \
/mnt/etc/nixos/configuration.nix

nixos-install --no-root-passwd --root /mnt

umount -Rl /mnt
zpool export -a