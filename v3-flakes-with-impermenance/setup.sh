#!/usr/bin/env bash

cd $( dirname -- "$0"; )

HOST_DIRECTORY="./hosts"

hosts_to_select_from=$(ls $HOST_DIRECTORY | grep -v common)

# Get the host from input and verify against configs
echo -e "Enter the hostname to deploy. \nChoices:"
for del in ${hosts_to_select_from[@]}
do
   echo -e "  - ${del}"
done
echo -n "> "
read hostname

if [ ! -d "$HOST_DIRECTORY/$hostname" ] ; then
    echo "ERROR: Entered host '${hostname}' not in hosts directory."
    echo "       Please enter value from above or create a new one in ./hosts/<NAME>."
    echo "       Quitting."
    exit 1
fi

setup_file="./${HOST_DIRECTORY}/${hostname}/prepare_disk.sh"
if [ ! -f "$setup_file" ]; then
    echo "ERROR: $setup_file does not exist. Quitting."
    exit 1
fi

echo "Host found. Disk setup found. Running ${setup_file}"

export $hostname
eval "${setup_file}"

exit

# FIND THE DISK diskNames

# WHAT ELSE?

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
IFS=$'\n' read -d '' -r -a DISKS < ${SCRIPTPATH}/disk_names

echo "${DISKS[@]}"


REMOVE DISK LOOP AND ONLY DO A SINGLE DISK< REMOE ALL DOUBLE SDISK SHIT


DISK- READ FROM file
SET THIS VARIABLE? INST_PARTSIZE_SWAP=4