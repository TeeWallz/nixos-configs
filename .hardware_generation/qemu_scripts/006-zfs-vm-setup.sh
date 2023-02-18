#!/usr/bin/env bash 

# Defining a helper variable to make the following commands shorter.
DISK=/dev/vda
BOOT_TYPE=EFI

if [ "$BOOT_TYPE" = "EFI" ]; then
    # EFI BOOT
    # Create partition table
    parted $DISK -- mklabel gpt

    # Create a /boot as $DISK-part1
    parted $DISK -- mkpart ESP fat32 1MiB 512MiB
    parted $DISK -- set 1 boot on

    # Create a /nix as $DISK-part2
    parted $DISK -s -- mkpart Nix 512MiB 100%

    # /boot partition for EFI
    mkfs.vfat "${DISK}1"

    # /boot partition for legacy boot
    # mkfs.ext4 "${DISK}1"

    # /nix partition
    mkfs.ext4 "${DISK}2"
else
    # LEGACY BOOT
    # Create partition table
    parted $DISK -- mklabel msdos

    # Create a /boot as $DISK-part1
    parted $DISK -- mkpart primary ext4 1M 512M
    parted $DISK -- set 1 boot on

    # Create a /nix as $DISK-part2
    parted $DISK -- mkpart primary ext4 512MiB 100%
fi


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
    # -O mountpoint=/ \
    rpool \
    "${DISK}2"
    # mirror \
#    $(for i in ${DISK}; do
#       printf "$i-part3 ";
#      done)


# My root dataset:
zfs create -p -o mountpoint=legacy rpool/local/root

# Before I even mount it, I create a snapshot while it is totally blank:
zfs snapshot rpool/local/root@blank

# And then mount it:
mount -t zfs rpool/local/root /mnt

# Then I mount the partition I created for the /boot:
mkdir /mnt/boot
mount /dev/the-boot-partition /mnt/boot

# Create and mount a dataset for /nix:
zfs create -p -o mountpoint=legacy rpool/local/nix
mkdir /mnt/nix
mount -t zfs rpool/local/nix /mnt/nix

# And a dataset for /home:
zfs create -p -o mountpoint=legacy rpool/safe/home
mkdir /mnt/home
mount -t zfs rpool/safe/home /mnt/home

# And finally, a dataset explicitly for state I want to persist between boots:
zfs create -p -o mountpoint=legacy rpool/safe/persist
mkdir /mnt/persist
mount -t zfs rpool/safe/persist /mnt/persist

# Note: in my systems, datasets under rpool/local are never backed up,
#     and datasets under rpool/safe are.


