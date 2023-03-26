#!/usr/bin/env bash


nix-shell -p git


source ~/disk
git clone https://github.com/ne9z/dotfiles-flake.git /mnt/etc/nixos
git -C /mnt/etc/nixos checkout openzfs-guide


for i in $DISK; do
  sed -i \
  "s|/dev/disk/by-id/|${i%/*}/|" \
  /mnt/etc/nixos/hosts/exampleHost/default.nix
  break
done

for i in $DISK; do
  sed -i \
  "s|/dev/disk/by-id/|${i%/*}/|" \
  .default_copy.nix
  break
done

for i in $DISK; do
  echo $i
done


diskNames=""
for i in $DISK; do
  diskNames="$diskNames \"${i##*/}\""
done

sed -i "s|\"bootDevices_placeholder\"|$diskNames|g" \
  /mnt/etc/nixos/hosts/exampleHost/default.nix

sed -i "s|\"hostId_placeholder\"|\"$(head -c4 /dev/urandom | od -A none -t x4| sed 's| ||g')\"|g" \
  /mnt/etc/nixos/hosts/exampleHost/default.nix

sed -i "s|\"systemType_placeholder\"|\"$(uname -m)-linux\"|g" \
  /mnt/etc/nixos/flake.nix

rootPwd=$(mkpasswd -m SHA-512 -s)

sed -i \
"s|rootHash_placeholder|${rootPwd}|" \
/mnt/etc/nixos/hosts/exampleHost/default.nix

git -C /mnt/etc/nixos config user.email "you@example.com"
git -C /mnt/etc/nixos config user.name "Alice Q. Nixer"

nixos-install --no-root-passwd --flake "git+file:///mnt/etc/nixos#exampleHost"

exit
