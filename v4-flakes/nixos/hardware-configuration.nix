# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-label/zamorak";
      fsType = "ext4";
    };
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
