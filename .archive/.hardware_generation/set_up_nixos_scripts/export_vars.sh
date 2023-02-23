#!/usr/bin/env bash

export rootdisk=$(ls /dev/disk/by-id/* | grep HARDDISK | grep -v part | head -n 1)
export use_passphrase="true"
export passphrase="test"
