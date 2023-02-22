
# Tom's NixOS repo'

https://github.com/PedroHLC/system-setup
https://github.com/nix-community/disko/blob/master/docs/quickstart.md


## Docs
- Official Docs: https://nixos.org/manual/nixos/stable/index.html#sec-installation-graphical
- Cheatsheet: https://nixos.wiki/wiki/Cheatsheet
- Cool Links: https://github.com/nix-community/awesome-nix
- Examples:
  - https://github.com/reckenrode/nixos-configs
  - https://github.com/michaelpj/nixos-config
  - https://gitlab.com/samueldr/nixos-configuration/-/tree/latest/
- Secrets?: https://github.com/Mic92/sops-nix#deploy-example


# Deploying
## SSH into server if convenient
```bash
# Set password to allow ssh
passwd

# Enable ssh
sudo systemctl start sshd

# Get IP to SSH into
if config

ssh nixos@192.168.x.x
```

## Partition disks and set up zfs pool
```bash
# Find the Disk ID you want to install on
ls /dev/disk/by-id/
DISK=/dev/disk/by-id/...

# If this is my QEMU VM, get it automatically
DISK=$(ls /dev/disk/by-id/* | grep HARD | grep -v part)

# Download the exmaple
curl -L https://raw.githubusercontent.com/nix-community/disko/master/example/zfs.nix /tmp/disko-config.nix

#Edit the sample to remove the second disk and remove the ZFS mirror

sudo nix run github:nix-community/disko --experimental-features 'nix-command flakes' -- --mode zap_create_mount /tmp/disko-config.nix --arg disks '[ "/dev/disk/by-id/..." ]'
```

## Download flakes
```bash
nix-shell -p git
git clone https://github.com/TeeWallz/nixos-configs.git
cd nixos-configs

```
## If a new pc, generate a new hardware-configuration.nix


sudo nixos-generate-config --no-filesystems --root /mnt

















