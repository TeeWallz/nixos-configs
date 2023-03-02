#!/usr/bin/env bash

set –e

./setup_disk_and_pool.sh
./setup_zfs_datasets.sh
./format_boot.sh
./setup_nixos_configuration.sh
