

```bash


sudo su
export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4
./hosts/common/optional/zfs-optin-persistence-disks/zfs-optin-persistence.sh 


sudo su
nix-shell -p git
git clone https://github.com/TeeWallz/nixos-configs.git /mnt/etc/nixos
cd /mnt/etc/nixos
git checkout go_back


nixos-install --flake .#zamorak
cd /
umount -Rl /mnt
zpool export -a



watch "df -h | sort -r -k 5 -i"


```