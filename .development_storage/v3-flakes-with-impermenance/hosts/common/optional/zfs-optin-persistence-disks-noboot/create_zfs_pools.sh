#!/usr/bin/env bash

set –e

# Define ZFS datasets
datasets_base="rpool/nixos"
dataset_local="${datasets_base}/local"
dataset_persist="${datasets_base}/persist"

dataset_nix="${dataset_local}/nix"
dataset_root="${dataset_local}/root"
# dataset_home="{$dataset_persist}/home"


echo "Creating ZFS root dataset"
# Create base dataset with encryption
zfs create \
    -o canmount=off -o mountpoint=none -o encryption=on \
    -o keylocation=prompt -o keyformat=passphrase $datasets_base

echo "Creating sub datasets"
# Create root datasets
zfs create -o mountpoint=legacy "${dataset_persist}"
zfs create -p -o mountpoint=legacy "${dataset_nix}"
zfs create -p -o mountpoint=legacy "${dataset_root}"
# Snapshot root before anything is created so that it can be wiped on boot
zfs snapshot "${dataset_root}@blank"

# Mount datasets here so we can install bootloader and Nixos
# mkdir /mnt/boot
# mkdir /mnt/nix

# mount -t zfs "${dataset_root}" /mnt/
# mount -t zfs "${dataset_nix}" /mnt/nix