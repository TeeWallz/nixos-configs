#!/usr/bin/env bash

# Be sure to run:
# nix-shell -p git
# git clone https://github.com/TeeWallz/nixos-configs.git && cd nixos-configs
# 

echo 'test' > /tmp/secret.key
DISCO_CONFIG=/home/nixos/nixos-configs/nixos/disko-config.nix

# Create partitions and zpool
nix run github:nix-community/disko --experimental-features 'nix-command flakes' -- --mode zap_create_mount $DISCO_CONFIG --arg disks '[ "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003" ]'

# Apply nix config

nixos-install --flake .#nixos