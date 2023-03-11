#!/use/bin/env bash

export DISK=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003
export INST_PARTSIZE_SWAP=4

cd $( dirname -- "$0"; )
../common/optional/zfs-optin-persistence-disks/setup.sh