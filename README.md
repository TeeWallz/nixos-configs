

ZFS Impermenance
Source:
https://openzfs.github.io/openzfs-docs/Getting Started/NixOS/index.html#root-on-zfs

# Preparation
* Boot into live ISO
* Set SSH Password
* Find target disk ```find /dev/disk/by-id/```
* Declare disk array ```export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'```
* Set swap size, set to 1 if you don’t want swap to take up too much space: ```export INST_PARTSIZE_SWAP=4```

# System Installation
```bash
#!/usr/bin/env bash

for i in ${DISK}; do

# wipe flash-based storage device to improve
# performance.
# ALL DATA WILL BE LOST
# blkdiscard -f $i

sgdisk --zap-all $i

sgdisk -n1:1M:+1G -t1:EF00 $i

sgdisk -n2:0:+4G -t2:BE00 $i

sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200 $i

if test -z $INST_PARTSIZE_RPOOL; then
    sgdisk -n3:0:0   -t3:BF00 $i
else
    sgdisk -n3:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 $i
fi

sgdisk -a1 -n5:24K:+1000K -t5:EF02 $i

sync && udevadm settle && sleep 3

cryptsetup open --type plain --key-file /dev/random $i-part4 ${i##*/}-part4
mkswap /dev/mapper/${i##*/}-part4
swapon /dev/mapper/${i##*/}-part4
done

```

Create boot pool:
```bash
zpool create \
    -o compatibility=grub2 \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/boot \
    -R /mnt \
    bpool \
    $(for i in ${DISK}; do
       printf "$i-part2 ";
      done)
```

Create root pool:
```bash
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
    -O mountpoint=/ \
    rpool \
   $(for i in ${DISK}; do
      printf "$i-part3 ";
     done)
```

# Create root system container:

## Unencrypted:
```bash
zfs create \
    -o canmount=off \
    -o mountpoint=none \
    rpool/nixos
```

## Encrypted:

Pick a strong password. Once compromised, changing password will not keep your data safe. See zfs-change-key(8) for more info:
```bash
zfs create \
    -o canmount=off \
    -o mountpoint=none \
    -o encryption=on \
    -o keylocation=prompt \
    -o keyformat=passphrase \
    rpool/nixos
```

# Create system datasets
Let NixOS declaratively manage mountpoints with mountpoint=legacy:
```bash
zfs create -o mountpoint=legacy     rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/
zfs create -o mountpoint=legacy rpool/nixos/home
mkdir /mnt/home
mount -t zfs  rpool/nixos/home /mnt/home
zfs create -o mountpoint=legacy  rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/log
zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root
mkdir /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot
zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start
```

# Format and mount ESP:
```bash
for i in ${DISK}; do
 mkfs.vfat -n EFI ${i}-part1
 mkdir -p /mnt/boot/efis/${i##*/}-part1
 mount -t vfat ${i}-part1 /mnt/boot/efis/${i##*/}-part1
done
```


# System Configuration


Download system configuration from this repo:

    mkdir -p /mnt/etc/nixos/
    curl -o /mnt/etc/nixos/configuration.nix -L \
    https://github.com/openzfs/openzfs-docs/raw/master/docs/Getting%20Started/NixOS/Root%20on%20ZFS/configuration.nix

Customize configuration to your hardware:

    for i in $DISK; do
        sed -i \
        "s|PLACEHOLDER_FOR_DEV_NODE_PATH|\"${i%/*}/\"|" \
        /mnt/etc/nixos/configuration.nix
        break
    done

    diskNames=""
    for i in $DISK; do
        diskNames="$diskNames \"${i##*/}\""
    done
    tee -a /mnt/etc/nixos/machine.nix <<EOF
    {
        bootDevices = [ $diskNames ];
    }
    EOF

Set root password:

    rootPwd=$(mkpasswd -m SHA-512 -s)

Declare password in configuration:

    sed -i \
    "s|PLACEHOLDER_FOR_ROOT_PWD_HASH|\""${rootPwd}"\"|" \
    /mnt/etc/nixos/configuration.nix

Optional: enable NetworkManager for easier wireless configuration and enable desktop environments. See man configuration.nix for details. By default, the system is installed without any other software.

Install system and apply configuration:

    nixos-install --no-root-passwd --root /mnt

Unmount filesystems:

    umount -Rl /mnt
    zpool export -a

Reboot:

    reboot

Optional: manage system configuration with git.

Optional: immutable root filesystem can be enabled by using this configuration file. Apply your own hardware configuration in this file, then execute:

    nixos-rebuild boot

Then reboot. You may need to make certain adjustments to where configuration files are stored, see NixOS wiki for details.







```bash
https://raw.githubusercontent.com/TeeWallz/nixos-configs/main/setup_vm.sh

curl -o /tmp/setup_vm.sh -L \
    https://raw.githubusercontent.com/TeeWallz/nixos-configs/main/setup_vm.sh

chmod +x /tmp/setup_vm.sh

/tmp/setup_vm.sh
```