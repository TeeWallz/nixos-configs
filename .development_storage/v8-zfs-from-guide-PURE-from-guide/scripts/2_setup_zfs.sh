#!/usr/bin/env bash

zfs create \
 -o canmount=off \
 -o mountpoint=none \
 rpool/nixos

zfs create -o mountpoint=legacy     rpool/nixos/root
zfs create -o mountpoint=legacy     rpool/nixos/home

mount -t zfs rpool/nixos/root /mnt/
mkdir /mnt/home
mount -t zfs  rpool/nixos/home /mnt/home
zfs create -o mountpoint=legacy  rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/log
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

mkdir -p /mnt/etc/
echo DISK=\"$DISK\" > ~/disk