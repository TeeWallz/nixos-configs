#!/usr/bin/env bash

set –e

mkdir -p /mnt/etc/nixos/
# curl -o /mnt/etc/nixos/configuration.nix -L \
# https://github.com/openzfs/openzfs-docs/raw/master/docs/Getting%20Started/NixOS/Root%20on%20ZFS/configuration.nix

cp ../configuration.nix /mnt/etc/nixos/configuration.nix


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

rootPwd=$(mkpasswd -m SHA-512 -s)

sed -i \
"s|PLACEHOLDER_FOR_ROOT_PWD_HASH|\""${rootPwd}"\"|" \
/mnt/etc/nixos/configuration.nix

nixos-install --no-root-passwd --root /mnt

umount -Rl /mnt
zpool export -a