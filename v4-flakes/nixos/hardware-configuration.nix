# # This is just an example, you should generate yours with nixos-generate-config and put it in here.
# {
#   fileSystems = {
#     "/" = {
#       device = "/dev/disk/by-label/zamorak";
#       fsType = "ext4";
#     };

#     "/boot" = {
#       device = "/dev/disk/by-label/ESP";
#       fsType = "vfat";
#     };

#   };

#   # Set your system kind (needed for flakes)
#   nixpkgs.hostPlatform = "x86_64-linux";
# }

{
  # imports =
  #   [ (modulesPath + "/profiles/qemu-guest.nix")
  #   ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003-part2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003-part1";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = hardware.enableRedistributableFirmware;
}