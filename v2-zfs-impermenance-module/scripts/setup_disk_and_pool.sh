#!/usr/bin/env bash

set –e

#https://openzfs.github.io/openzfs-docs/Getting Started/NixOS/index.html#root-on-zfs

# STEP 1 - SET UP PARTITITONS
# GOAL:
#   PARTITION 5: BIOS BOOT?     (24KiB - 1MiB)
#   PARTITION 1: EFI            (1MiB - 1GiB)
#   PARTITION 2: ZFS BOOT POOL  (1GiB - 4GiB)
#   PARTITION 4: LINUX SWAP     (4GiB - 4+INST_PARTSIZE_SWAP GiB)
#   PARTITION 3: DATA ROOT      (Fill)

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

# Do we have multiple disks? If so, activate zpool mirror
disk_arr=( $DISK )
disk_count=${#disk_arr[@]}
args_mirror=""
if [ $disk_count -gt 1 ]; then
    args_mirror="mirror"
fi

# Create ZFS Boot pool
    # -O mountpoint=/boot \
    # -R /mnt \
    # -m none - No mount
zpool create \
    -o compatibility=grub2 \
    -o ashift=12 \
    -o autotrim=on \
    -m none \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    bpool $args_mirror\
    $(for i in ${DISK}; do
       printf "$i-part2 ";
      done)

# Create ZFS Root pool
    # -O mountpoint=/ \
    #-R /mnt \
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -m none \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    rpool $args_mirror\
   $(for i in ${DISK}; do
      printf "$i-part3 ";
     done)
