#!/usr/bin/env bash 

ISO_PATH="/tmp/snowflakeos.iso"

HOME_DIR=$HOME
# HOME_DIR="/run/media/nixos/home/tom"        
DISK_DIR="quemu/nixos"
DISK_NAME="snowflakeos_disk.qcow2"

DISK_PATH="$HOME_DIR/$DISK_DIR/$DISK_NAME"

echo $DISK_PATH

qemu-system-x86_64 -enable-kvm -boot d \
    -m 2G -cpu host -smp 2 -hda /home/tom/quemu/nixos/snowflakeos_disk.qcow2 \
    -cdrom $ISO_PATH \

