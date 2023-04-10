

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

mount -t tmpfs none /tmp
nixos-install --flake .#zamorak

```