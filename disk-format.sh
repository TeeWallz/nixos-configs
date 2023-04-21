# https://cheat.readthedocs.io/en/latest/nixos/zfs_install.html

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4

sgdisk --zap-all $DISK
zpool labelclear -f rpool

# I DID NOT create partition 2 since I don't need legacy (BIOS) boot
# Partition 2 will be the boot partition, needed for legacy (BIOS) boot
# sgdisk -a1 -n2:34:2047 -t2:EF02 $DISK

# If you need EFI support, make an EFI partition:
sgdisk -n3:1M:+512M -t3:EF00 $DISK

# Partition 1 will be the main ZFS partition, using up the remaining space on the drive.
sgdisk -n1:0:0 -t1:BF01 $DISK

sync && udevadm settle && sleep 3                       # Wait for all disk tasks to complete

# Create the pool. If you want to tweak this a bit and you're feeling adventurous, you
# might try adding one or more of the following additional options:
# To disable writing access times:
#   -O atime=off
# To enable filesystem compression:
#   -O compression=lz4
# To improve performance of certain extended attributes:
#   -O xattr=sa
# For systemd-journald posixacls are required
#   -O  acltype=posixacl
# To specify that your drive uses 4K sectors instead of relying on the size reported
# by the hardware (note small 'o'):
#   -o ashift=12
#
# The 'mountpoint=none' option disables ZFS's automount machinery; we'll use the
# normal fstab-based mounting machinery in Linux.
# '-R /mnt' is not a persistent property of the FS, it'll just be used while we're installing.

root_pool="rpool"
datasets_base="${root_pool}/nixos"
dataset_local="${datasets_base}/local"
dataset_root="${dataset_local}/root"
dataset_home="${dataset_local}/home"
dataset_nix="${dataset_local}/nix"
dataset_persist="${datasets_base}/persist"

zpool create -O mountpoint=none -O atime=off -O \
    compression=lz4 -O xattr=sa -O acltype=posixacl -o ashift=12 \
    -R /mnt rpool $DISK-part1

# Create the filesystems. This layout is designed so that /home is separate from the root
# filesystem, as you'll likely want to snapshot it differently for backup purposes. It also
# makes a "nixos" filesystem underneath the root, to support installing multiple OSes if
# that's something you choose to do in future.


zfs create -o mountpoint=none   $datasets_base
zfs create -o mountpoint=none   $dataset_local

zfs create -o mountpoint=legacy $dataset_root
zfs create -o mountpoint=legacy $dataset_nix
zfs create -o mountpoint=legacy $dataset_home

zfs create -o mountpoint=legacy $dataset_persist
zfs snapshot "${dataset_root}@blank"

# Mount the filesystems manually. The nixos installer will detect these mountpoints
# and save them to /mnt/nixos/hardware-configuration.nix during the install process.
mount -t zfs $dataset_root /mnt
mkdir /mnt/home
mkdir /mnt/nix
mkdir /mnt/persist
mount -t zfs $dataset_home /mnt/home
mount -t zfs $dataset_nix /mnt/nix
mount -t zfs $dataset_persist /mnt/persist
sync && udevadm settle && sleep 3                       # Wait for all disk tasks to complete


# If you need to boot EFI, you'll need to set up /boot as a non-ZFS partition.
mkfs.vfat $DISK-part3
mkdir /mnt/boot
mount $DISK-part3 /mnt/boot

mount -t tmpfs none /tmp