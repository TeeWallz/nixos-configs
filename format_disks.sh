#!/usr/bin/env bash

DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
INST_PARTSIZE_SWAP=4

for i in ${DISK}; do

    # wipe flash-based storage device to improve
    # performance.
    # ALL DATA WILL BE LOST
    # blkdiscard -f $i

    sgdisk --zap-all $i

    sgdisk -n1:1M:+1G -t1:EF00 $i

    sgdisk -n2:0:+4G -t2:BE00 $i

    sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200 $i

    if test -z $INST_PARTSIZE_RPOOL; then
        sgdisk -n3:0:0   -t3:BF00 $i
    else
        sgdisk -n3:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 $i
    fi

    sgdisk -a1 -n5:24K:+1000K -t5:EF02 $i

    sync && udevadm settle && sleep 3

    # cryptsetup open --type plain --key-file /dev/random $i-part4 ${i##*/}-part4
    # mkswap /dev/mapper/${i##*/}-part4
    # swapon /dev/mapper/${i##*/}-part4
done






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

# Unencrypted zroot
zfs create \
 -o canmount=off \
 -o mountpoint=none \
 rpool/nixos

zfs create -o mountpoint=legacy     rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/
zfs create -o mountpoint=legacy rpool/nixos/home
mkdir /mnt/home
mount -t zfs rpool/nixos/home /mnt/home
zfs create -o mountpoint=legacy  rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/log
zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root
mkdir /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib
mount -t zfs rpool/nixos/var/lib /mnt/var/lib
mount -t zfs rpool/nixos/var/log /mnt/var/log
zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start

for i in ${DISK}; do
 mkfs.vfat -n EFI ${i}-part1
 mkdir -p /mnt/boot/efis/${i##*/}-part1
 mount -t vfat ${i}-part1 /mnt/boot/efis/${i##*/}-part1
done

mkdir -p /mnt/etc/
echo DISK=\"$DISK\" > ~/disk

# nix-shell -p git
# source ~/disk



