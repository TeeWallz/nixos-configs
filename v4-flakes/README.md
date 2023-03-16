Sources:

https://github.com/Misterio77/nix-starter-configs
https://github.com/Misterio77/nix-config



```bash
sudo su
export i='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'

sgdisk --zap-all $i
sgdisk $i -o
sgdisk -n1:1M:+1G -t1:EF00 $i
sgdisk $i -n 2

mkfs.vfat -n ESP ${i}-part1
mkfs.ext4 "${i}-part2"
e2label "${i}-part2" zamorak

mount "${i}-part2" /mnt/
mkdir /mnt/boot
mount -t vfat "${i}-part1" /mnt/boot



cd /tmp
curl -o /tmp/nixos-configs.zip -L "https://github.com/TeeWallz/nixos-configs/archive/refs/heads/main.zip"
unzip /tmp/nixos-configs.zip
cd /tmp/nixos-configs-main/v4-flakes/

nixos-install --flake .#zamorak
```
