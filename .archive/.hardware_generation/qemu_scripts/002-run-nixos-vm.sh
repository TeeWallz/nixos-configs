#!/usr/bin/env bash 

HOME_DIR=$HOME
# HOME_DIR="/run/media/nixos/home/tom"        
DISK_DIR="quemu/nixos"
DISK_NAME="nixos_disk.qcow2"
DISK_PATH="$HOME_DIR/$DISK_DIR/$DISK_NAME"

SPICE_PORT=5924




echo $DISK_PATH

qemu-system-x86_64 -enable-kvm -boot d \
    -m 2G -cpu host -smp 2 -hda $DISK_PATH \
    -nic user,hostfwd=tcp::5022-:22 \
    # -vga qxl \
    -spice port=${SPICE_PORT},addr=127.0.0.1,disable-ticketing=on \
    -device virtio-serial-pci \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
    -chardev spicevmc,id=spicechannel0,name=vdagent
    # -monitor stdio

