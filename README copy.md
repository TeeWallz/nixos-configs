

ZFS Impermenance
Source:
https://openzfs.github.io/openzfs-docs/Getting Started/NixOS/index.html#root-on-zfs


# First setup that works consistently
```bash
sudo su

curl -o /tmp/setup_vm.sh -L \
    https://raw.githubusercontent.com/TeeWallz/nixos-configs/main/setup_vm.sh

chmod +x /tmp/setup_vm.sh

/tmp/setup_vm.sh
```