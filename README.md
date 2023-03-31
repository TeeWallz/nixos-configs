# Tom's NixOS configs

Sources:

- [ZFS Support](https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS.html)


# Bootstrap

1. Disable Secure Boot. ZFS modules can not be loaded if Secure Boot is enabled.
1. Download `NixOS Live Image <https://nixos.org/download.html#download-nixos> and boot from it.
1. Connect to the Internet.
2. Set root password or ``/root/.ssh/authorized_keys``.
3. Start SSH server::

        systemctl restart sshd

4. Connect from another computer::

        ssh root@192.168.1.91
# First setup that works consistently
```bash
sudo su
nix-shell -p git

git clone https://github.com/TeeWallz/nixos-configs.git /mnt/etc/nixos
cd /mnt/etc/nixos
git checkout combining_zfs_and_misterio



nixos-install --no-root-passwd --flake "git+file:///mnt/etc/nixos#guthix"

umount -Rl /mnt
zpool export -a

```