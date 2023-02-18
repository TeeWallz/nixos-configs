#!/bin/bash

NIXOS_DISK_DIR="$HOME/quemu/nixos"
NIXOS_URL="https://netcologne.dl.sourceforge.net/project/snowflakeos/snowflakeos-unstable-x86_64-linux.iso"
DISK_NAME="snowflakeos_disk.qcow2"
ISO_PATH="/tmp/snowflakeos.iso"

mkdir -p $NIXOS_DISK_DIR
cd $NIXOS_DISK_DIR


if [[ ! -f $ISO_PATH ]]
then
    # download the minimal image:
    wget -O $ISO_PATH $NIXOS_URL
fi


# config the image
# cmd template -> qemu-img create -f qcow2 NOME.img XG
qemu-img create -f qcow2 $DISK_NAME 30G
# command used to create, convert and modify disk images
# -f:
#   Stands for format option. qcow2 stands for copy on write 2nd generation.
#qemu-img resize $DISK_NAME +10G


# bootstrap the machine
# cmd template -> qemu-system-x86_64 -boot d -cdrom image.iso -m 512 -hda mydisk.img
qemu-system-x86_64 -enable-kvm -boot d \
    -cdrom $ISO_PATH \
    -m 2G -cpu host -smp 2 -hda $DISK_NAME

# qemu-system-x86_64 -cdrom $ISO_PATH -boot order=d -drive file=$DISK_NAME,format=qcow2


# command used to boot an image
# to get the help use the -h flag
# -enable-kvm:
#   Enable KVM full virtualization support. This option is only available if KVM support
#   is enabled when compiling.
# -boot
#   Specify boot order drives as a string of drive letters. Valid drive letters depend on
#   the target architechture. The x86 PC uses: a, b (floppy 1 and 2), c (first hard disk)
#   d (first CD-ROM), n-p (Etherboot from network adapter 1-4), hard disk boot is the default.
# -cdrom
#   Use file as CD-ROM image (you cannot use -hdc and -cdrom at the same time). You can use
#   the host CD-ROM by using /dev/cdrom as filename.
# -m
#   Set the quantity of RAM.
# -hda
#   Use file as hard disk 0, 1, 2 or image.

# start the vm after closing it
 qemu-system-x86_64 -enable-kvm -boot d \
     -m 2G -cpu host -smp 2 -hda $DISK_NAME
