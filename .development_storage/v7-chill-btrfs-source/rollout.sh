#!/usr/bin/env bash

sudo su

cd /tmp
curl -o /tmp/nixfiles.zip -L "https://github.com/TeeWallz/nixfiles/archive/refs/heads/master.zip"
unzip /tmp/nixfiles.zip
cd /tmp/nixfiles-master

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4
./hosts/common/zfs-optin-persistence-raw-boot/zfs-optin-persistence.sh

echo "Mounts:"
cat /proc/mounts | grep "rpool\|boot"
echo ""

nixos-install --flake .#zamorak

zpool export rpool
