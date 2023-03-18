#!/usr/bin/env bash

cd $( dirname -- "$0"; )

./zfs-optin-persistence-disks.sh
./zfs-optin-persistence-zfs.sh