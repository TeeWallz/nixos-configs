#!/usr/bin/env bash

set –e
# Define ZFS datasets
dataset_boot="bpool/nixos"
dataset_boot_root="${dataset_boot}/root"

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

# Create boot datasets
zfs create -o mountpoint=none "${dataset_boot}"
zfs create -o mountpoint=legacy "${dataset_boot_root}"

# Mount datasets here so we can install bootloader and Nixos
mount -t zfs "${dataset_root}" /mnt/

mkdir /mnt/boot
mkdir /mnt/nix
mount -t zfs "${dataset_boot_root}" /mnt/boot
mount -t zfs "${dataset_nix}" /mnt/nix