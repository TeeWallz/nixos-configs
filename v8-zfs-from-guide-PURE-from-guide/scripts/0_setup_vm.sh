#!/usr/bin/env bash

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4

./1_setup_disks.sh
./2_setup_zfs.sh
