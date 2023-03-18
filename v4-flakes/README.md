Sources:

https://github.com/Misterio77/nix-starter-configs
https://github.com/Misterio77/nix-config



```bash
sudo su
export i='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'

export my_hostname=$(cat /etc/hostname)

if [ "$my_hostname" != "nixos" ]; then
     echo "dumbass"
else
sgdisk --zap-all $i
sgdisk $i -o
sgdisk -n1:1M:+1G -t1:EF00 $i
sgdisk $i -n 2

sync && udevadm settle && sleep 3

mkfs.vfat -n ESP "${i}-part1"
mkfs.ext4 "${i}-part2"

sync && udevadm settle && sleep 3

e2label "${i}-part2" zamorak

sync && udevadm settle && sleep 3

ls /dev/disk/by-label/*

mount /dev/disk/by-label/zamorak /mnt/
mkdir /mnt/boot
mount -t vfat /dev/disk/by-label/ESP /mnt/boot
fi





if [ "$my_hostname" != "nixos" ]; then
     echo "dumbass"
else
    cd /tmp
    curl -o /tmp/nixos-configs.zip -L "https://github.com/TeeWallz/nixos-configs/archive/refs/heads/main.zip"
    unzip /tmp/nixos-configs.zip
    cd /tmp/nixos-configs-main/v4-flakes/

    nixos-install --flake .#zamorak
fi

```


```
mount /dev/disk/by-label/zamorak /mnt/
mount -t vfat /dev/disk/by-label/ESP /mnt/boot

```

```
cd /tmp
rm /tmp/nixos-configs.zip
rm -rf /tmp/nixos-configs-main/
curl -o /tmp/nixos-configs.zip -L "https://github.com/TeeWallz/nixos-configs/archive/refs/heads/main.zip"
unzip /tmp/nixos-configs.zip
cd /tmp/nixos-configs-main/v4-flakes/

nixos-install --flake .#zamorak
```



mount /dev/disk/by-uuid/F03C-5E9E /mnt/
mount -t vfat /dev/disk/by-uuid/ca45136c-4435-4fc7-b19c-cf848a17c7a5 /mnt/boot


