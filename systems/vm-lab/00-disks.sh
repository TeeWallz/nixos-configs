#!/usr/bin/env sh
set -o errexit

# Username for mounting persient zpool mount to various /home folders at bottom of script
USERNAME=tom

# Hard disk type. Defaults to EFI, but can use GPT if needed
BOOT_TYPE=EFI

# Define disk helper variable, and name partition variables explicitly
DISK=$(ls /dev/disk/by-id/* | grep HARD | grep -v part)
PARTITION_BOOT="${DISK}-part1"
PARTITION_ZPOOL="${DISK}-part2"

# Create a boot and zpool partition
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
    mkfs.vfat $PARTITION_BOOT

    # /boot partition for legacy boot
    # mkfs.ext4 $PARTITION_BOOT

    # /nix partition
    mkfs.ext4 $PARTITION_ZPOOL
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

# Swaps.
#mkswap /dev/nvme0n1p3 # (TODO)
#swapon /dev/nvme0n1p3 # (TODO)

# Create pool.
zpool create -f zroot $PARTITION_ZPOOL
zpool set autotrim=on zroot
zfs set compression=lz4 zroot
zfs set mountpoint=none zroot
zfs create -o refreservation=10G -o mountpoint=none zroot/reserved

# System volumes.
zfs create -o mountpoint=none zroot/data
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=legacy zroot/ROOT/empty
zfs create -o mountpoint=legacy zroot/ROOT/nix
zfs create -o mountpoint=legacy zroot/ROOT/residues # TODO: Move to zroot/ROOT
zfs create -o mountpoint=legacy zroot/data/persistent
zfs create -o mountpoint=legacy zroot/data/melina
zfs snapshot zroot/ROOT/empty@start

# Different recordsize
zfs create -o mountpoint=legacy -o recordsize=16K zroot/data/btdownloads
zfs create -o mountpoint=none -o recordsize=1M zroot/games
zfs create -o mountpoint=legacy zroot/games/home
zfs create -o mountpoint=legacy -o recordsize=16K \
	-o logbias=latency zroot/data/postgres

# Encrypted volumes.
zfs create -o encryption=on -o keyformat=passphrase \
	-o mountpoint=/home/$USERNAME/.encrypted zroot/data/encrypted
zfs create -o encryption=on -o keyformat=passphrase \
	-o mountpoint=/home/$USERNAME/.mozilla zroot/data/mozilla

# Mount & Permissions
mount -t zfs zroot/ROOT/empty /mnt
mkdir -p /mnt/nix /mnt/home/melinapn /mnt/home/$USERNAME /mnt/var/persistent
mount -t zfs zroot/ROOT/nix /mnt/nix
mount -t zfs zroot/data/melina /mnt/home/melinapn
chown 1002:100 /mnt/home/melinapn
chmod 0700 /mnt/home/melinapn
mkdir /mnt/home/$USERNAME/Games
mount -t zfs zroot/games/home /mnt/home/$USERNAME/Games
chown -R 1001:100 /mnt/home/$USERNAME
chmod 0700 /mnt/home/$USERNAME
chmod 0750 /mnt/home/$USERNAME/Games
mount -t zfs zroot/data/persistent /mnt/var/persistent
mount -t zfs zroot/ROOT/residues /mnt/var/residues

echo "Finished. But you\'ll need to set the postgresql volume permission and ownership eventually."