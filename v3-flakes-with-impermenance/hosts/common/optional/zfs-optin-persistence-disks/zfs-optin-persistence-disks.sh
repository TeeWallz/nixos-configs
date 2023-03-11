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
#   PARTITION 3: LINUX SWAP     (?)
#   PARTITION 2: DATA ROOT      (Fill)
#       rpool
#           nixos
#               persist -> *
#               nix     -> /nix
#               root    -> / (Wiped)

sgdisk --zap-all ${DISK}                                # Wipe disk
sgdisk -n1:1M:+1G -t1:EF00 ${DISK}                      # EFI Boot
sgdisk -n3:0:+${INST_PARTSIZE_SWAP}G -t4:8200 ${DISK}   # Swap
if test -z $INST_PARTSIZE_RPOOL; then                   # ZFS Root Pool
    sgdisk -n2:0:0   -t3:BF00 ${DISK}
else
    sgdisk -n2:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 ${DISK}
fi
sync && udevadm settle && sleep 3                       # Wait for all disk tasks to complete

# Activate swap - TODO - Why cryptswap open?
mkswap "${DISK}-part3"
swapon "${DISK}-part3"

mkfs.vfat -n ESP "${DISK}-part1"

zpool create \
    -o ashift=12 -o autotrim=on -m none  -O acltype=posixacl -O canmount=off \
    -O compression=zstd -O dnodesize=auto  -O normalization=formD \
    -O relatime=on -O xattr=sa rpool "${DISK}-part3 "

