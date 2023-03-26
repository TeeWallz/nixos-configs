
```
<!-- nix-shell -p gitMinimal nano -->
<!-- git clone https://github.com/TeeWallz/nixfiles.git -->
<!-- cd nixfiles -->

sudo su

cd /tmp
curl -o /tmp/nixfiles.zip -L "https://github.com/TeeWallz/nixfiles/archive/refs/heads/master.zip"
unzip /tmp/nixfiles.zip
cd /tmp/nixfiles-master

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4
./hosts/common/zfs-optin-persistence-raw-boot/zfs-optin-persistence-zfs.sh

nixos-install --flake .#zamorak

```

curl -s https://raw.githubusercontent.com/TeeWallz/nixfiles/master/rollout.sh | bash
