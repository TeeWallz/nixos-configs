{ modulesPath, ... }: {
  imports = [
    # ../common/optional/btrfs-optin-persistence.nix
    # ../common/optional/zfs-optin-persistence.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../common/optional/zfs_boot_and_data
  ];

  boot = {
    devNodes = "/dev/disk/by-id/";
    bootDevices = [ "ata-QEMU_HARDDISK_QM00003" ];
    immutable = true;
    hostId = "d4780b86";
    availableKernelModules = [
      # for booting virtual machine
      # with virtio disk controller
      "virtio_pci"
      "virtio_blk"
      # for sata drive
      "ahci"
      # for nvme drive
      "nvme"
      # for external usb drive
      "uas"
    ];
    # install bootloader to fallback location
    # set to "false" if multiple systems are installed
    removableEfi = true;
    kernelParams = [ ];
    sshUnlock = {
      enable = false;
      authorizedKeys = [ ];
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
