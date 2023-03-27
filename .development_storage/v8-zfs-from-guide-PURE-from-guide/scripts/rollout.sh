nix-shell -p git

git clone https://github.com/TeeWallz/nixos-configs.git /mnt/etc/nixos
nixos-install --no-root-passwd --flake "git+file:///mnt/etc/nixos#guthix"

umount -Rl /mnt
zpool export -a
