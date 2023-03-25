
export DISK='/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003'
export INST_PARTSIZE_SWAP=4

for i in ${DISK}; do

# wipe flash-based storage device to improve
# performance.
# ALL DATA WILL BE LOST
# blkdiscard -f $i

sgdisk --zap-all $i

sgdisk -n1:1M:+1G -t1:EF00 $i

sgdisk -n2:0:+4G -t2:BE00 $i

sgdisk -n4:0:+${INST_PARTSIZE_SWAP}G -t4:8200 $i

if test -z $INST_PARTSIZE_RPOOL; then
    sgdisk -n3:0:0   -t3:BF00 $i
else
    sgdisk -n3:0:+${INST_PARTSIZE_RPOOL}G -t3:BF00 $i
fi

sgdisk -a1 -n5:24K:+1000K -t5:EF02 $i

sync && udevadm settle && sleep 3

cryptsetup open --type plain --key-file /dev/random $i-part4 ${i##*/}-part4
mkswap /dev/mapper/${i##*/}-part4
swapon /dev/mapper/${i##*/}-part4
done

zpool create \
    -o compatibility=grub2 \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/boot \
    -R /mnt \
    bpool \ 
    $(for i in ${DISK}; do
       printf "$i-part2 ";
      done)


zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    rpool \ 
   $(for i in ${DISK}; do
      printf "$i-part3 ";
     done)

zfs create \
 -o canmount=off \
 -o mountpoint=none \
 rpool/nixos

zfs create -o mountpoint=legacy     rpool/nixos/root
mount -t zfs rpool/nixos/root /mnt/
zfs create -o mountpoint=legacy rpool/nixos/home
mkdir /mnt/home
mount -t zfs  rpool/nixos/home /mnt/home
zfs create -o mountpoint=legacy  rpool/nixos/var
zfs create -o mountpoint=legacy rpool/nixos/var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/log
zfs create -o mountpoint=none bpool/nixos
zfs create -o mountpoint=legacy bpool/nixos/root
mkdir /mnt/boot
mount -t zfs bpool/nixos/root /mnt/boot
zfs create -o mountpoint=legacy rpool/nixos/empty
zfs snapshot rpool/nixos/empty@start

for i in ${DISK}; do
 mkfs.vfat -n EFI ${i}-part1
 mkdir -p /mnt/boot/efis/${i##*/}-part1
 mount -t vfat ${i}-part1 /mnt/boot/efis/${i##*/}-part1
done

mkdir -p /mnt/etc/
echo DISK=\"$DISK\" > ~/disk

nix-shell -p git


source ~/disk
git clone https://github.com/ne9z/dotfiles-flake.git /mnt/etc/nixos
git -C /mnt/etc/nixos checkout openzfs-guide


for i in $DISK; do
  sed -i \
  "s|/dev/disk/by-id/|${i%/*}/|" \
  /mnt/etc/nixos/hosts/exampleHost/default.nix
  break
done

diskNames=""
for i in $DISK; do
  diskNames="$diskNames \"${i##*/}\""
done

sed -i "s|\"bootDevices_placeholder\"|$diskNames|g" \
  /mnt/etc/nixos/hosts/exampleHost/default.nix

sed -i "s|\"hostId_placeholder\"|\"$(head -c4 /dev/urandom | od -A none -t x4| sed 's| ||g')\"|g" \
  /mnt/etc/nixos/hosts/exampleHost/default.nix

sed -i "s|\"systemType_placeholder\"|\"$(uname -m)-linux\"|g" \
  /mnt/etc/nixos/flake.nix

rootPwd=$(mkpasswd -m SHA-512 -s)

sed -i \
"s|rootHash_placeholder|${rootPwd}|" \
/mnt/etc/nixos/hosts/exampleHost/default.nix

git -C /mnt/etc/nixos config user.email "you@example.com"
git -C /mnt/etc/nixos config user.name "Alice Q. Nixer"

nixos-install --no-root-passwd --flake "git+file:///mnt/etc/nixos#exampleHost"

exit


