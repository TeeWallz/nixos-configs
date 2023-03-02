
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


# Setup access and pull flake
## SSH into server if convenient
```bash
# Set password to allow ssh
passwd

# Get IP to SSH into
if config

ssh nixos@192.168.x.x
```
## Download flakes
```bash
nix-shell -p git
git clone https://github.com/TeeWallz/nixos-configs.git
cd nixos-configs

```



# Developing/Creating the config the first time
## Partition disks and set up zfs pool
```bash
# Find the Disk ID you want to install on
# If this is my QEMU VM, get it automatically
ls /dev/disk/by-id/* | grep HARD | grep -v part
```


## Testing disk examples
curl -L https://raw.githubusercontent.com/nix-community/disko/master/example/zfs.nix /tmp/disko-config.nix

#Edit the sample to remove the second disk and remove the ZFS mirror

```
## Generate a new hardware-configuration.nix
```bash
sudo nixos-generate-config --no-filesystems --root /mnt
```

Upload this into github next to configuration.nix
```

## Add the following to the top of the configuration.nix, editing the <disk-name> section
```nix
imports =
 [ # Include the results of the hardware scan.
   ./hardware-configuration.nix
   "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
   (pkgs.callPackage ./disko-config.nix {
     disks = ["/dev/<disk-name>"]; # replace this with your disk name i.e. /dev/nvme0n1
   })
 ];
```
Add this to git



# This isn't our first roedo
```bash
# ZFS Save key into /tmp/secret.key if encrypting
nano /tmp/secret.key



DISCO_CONFIG=/tmp/disko-config.nix

sudo nix run github:nix-community/disko --experimental-features 'nix-command flakes' -- --mode zap_create_mount $DISCO_CONFIG --arg disks '[ "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003" ]'
```


# Run the reployment either way

```bash
sudo nixos-install --flake .#nixos
```











