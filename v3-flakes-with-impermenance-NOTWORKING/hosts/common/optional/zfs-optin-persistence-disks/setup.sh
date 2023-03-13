#!/usr/bin/env bash

cd $( dirname -- "$0"; )

./format_disks.sh
./create_zfs_pools.sh