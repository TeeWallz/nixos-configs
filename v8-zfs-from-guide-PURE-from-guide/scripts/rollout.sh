mkdir /mnt/etc/nixos

cd /tmp
curl -o /tmp/nixfiles.zip -L "https://github.com/TeeWallz/nixos-configs/archive/refs/heads/main.zip"
unzip /tmp/nixfiles.zip

cd /tmp/nixos-configs-main/v8-zfs-from-guide-PURE-from-guide/dotfiles-flake/
cp -r * /mnt/etc/nixos




