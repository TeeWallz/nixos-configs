{ modulesPath, lib, config, ... }:
{
  imports = [
    # ../common/optional/btrfs-optin-persistence.nix
    ../common/optional/zfs-optin-persistence.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # fileSystems = {
  #   "/boot" = {
  #     device = "/dev/disk/by-label/ESP";
  #     fsType = "vfat";
  #   };
  # };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/AC99-DD39";
      fsType = "vfat";
    };
  };

  # swapDevices = [{
    # device = "/swap/swapfile";
    # size = 8196;
  # }];
  
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform.system = "x86_64-linux";
}
