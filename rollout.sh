nix-shell -p git

git clone https://github.com/TeeWallz/nixos-configs.git /mnt/etc/nixos
cd /mnt/etc/nixos
git reset --hard 7f6e48b7226347bda167a9b2a2173b04e11dc3c1


nixos-install --no-root-passwd --flake "git+file:///mnt/etc/nixos#guthix"

umount -Rl /mnt
zpool export -a
