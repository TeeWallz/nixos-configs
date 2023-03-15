# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  fileSystems."/" = {
    device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003";
    fsType = "ext4";
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
