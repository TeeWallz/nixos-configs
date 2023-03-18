#export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
if [[ -z "${DISK}" ]]; then
    echo "ERROR: Environment variable 'DISK' not set to apply partitions to."
    echo "       Please set accordingly. Quitting."
    exit 1
fi

#export INST_PARTSIZE_SWAP=4
if [[ -z "${INST_PARTSIZE_SWAP}" ]]; then
    echo "ERROR: Environment variable 'INST_PARTSIZE_SWAP' not set to apply partitions to."
    echo "       Please set accordingly. Quitting."
    exit 1
fi

#   PARTITION 1: EFI            (1MiB - 1GiB)
#   PARTITION 2: ZFS BOOT POOL  (1GiB - 4GiB)
#       bpool
#           nixos
#               root
#   PARTITION 3: DATA ROOT      (Fill)
#       rpool
#           nixos
#               persist -> *
#               nix     -> /nix
#               root    -> / (Wiped)
#   PARTITION 4: LINUX SWAP     (?)
#   PARTITION 5: BIOS BOOT?     (?)

sgdisk --zap-all ${DISK}                                # Wipe disk
sgdisk -n1:1M:+1G -t1:EF00 ${DISK}                      # EFI Boot
sgdisk -n2:0:+4G -t2:BE00 ${DISK}                       # ZFS Boot Pool
sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200 ${DISK}   # Swap
if test -z $INST_PARTSIZE_RPOOL; then                   # ZFS Root Pool
    sgdisk -n3:0:0   -t3:BF00 ${DISK}
else
    sgdisk -n3:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 ${DISK}
fi
sgdisk -a1 -n5:24K:+1000K -t5:EF02 ${DISK}              # BIOS Boot
sync && udevadm settle && sleep 3                       # Wait for all disk tasks to complete

# Activate swap - TODO - Why cryptswap open?
cryptsetup open --type plain --key-file /dev/random "${DISK}-part4"
mkswap "${DISK}-part4"
swapon "${DISK}-part4"

mkfs.vfat -n EFI "${DISK}-part1"


zpool create \
    -o ashift=12 -o autotrim=on -m none  -O acltype=posixacl -O canmount=off \
    -O compression=zstd -O dnodesize=auto  -O normalization=formD \
    -O relatime=on -O xattr=sa rpool "${DISK}-part3"

zpool create \
    -o compatibility=grub2 -o ashift=12 -o autotrim=on -m none \
    -O acltype=posixacl -O canmount=off -O compression=lz4 -O devices=off \
    -O normalization=formD -O relatime=on -O xattr=sa bpool "${DISK}-part2"
