#!/usr/bin/env bash

# For each disk in DISK
for i in ${DISK}; do
    # wipe flash-based storage device to improve performance.
    # ALL DATA WILL BE LOST
    # blkdiscard -f $i

    sgdisk --zap-all $i
    # Partition 1: EFI/ESP
    sgdisk -n1:1M:+1G -t1:EF00 $i
    # Partition 2: ZFS Boot Pool - Solaris Boot Type
    sgdisk -n2:0:+4G -t2:BE00 $i
    # Partition 4: Linux swap
    sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200 $i
    # Partition 3 - ZFS Root pool. Defined amount, or fill
    if test -z $INST_PARTSIZE_RPOOL; then
        sgdisk -n3:0:0   -t3:BF00 $i
    else
        sgdisk -n3:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 $i
    fi
    # Partition 5 - BIOS BOOT
    sgdisk -a1 -n5:24K:+1000K -t5:EF02 $i
    # Wait for all disk tasks to complete
    sync && udevadm settle && sleep 3

    cryptsetup open --type plain --key-file /dev/random $i-part4 ${i##*/}-part4
    mkswap /dev/mapper/${i##*/}-part4
    swapon /dev/mapper/${i##*/}-part4
done

# Boop zfs pool
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

# zfs root pool
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
