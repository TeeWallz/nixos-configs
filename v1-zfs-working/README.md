
ZFS Impermenance
Source:
https://openzfs.github.io/openzfs-docs/Getting Started/NixOS/index.html#root-on-zfs


# First setup that works consistently
```bash
sudo su

export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4
export GITHUB_ROOT_DIR="https://raw.githubusercontent.com/TeeWallz/nixos-configs/main/v1-zfs-working"
export SETUP_URL="${GITHUB_ROOT_DIR}/setup_vm.sh"
export NIX_CONFIG_URL="${GITHUB_ROOT_DIR}/configuration.nix"

curl -o /tmp/setup_vm.sh -L ${SETUP_URL}
chmod +x /tmp/setup_vm.sh

/tmp/setup_vm.sh
```