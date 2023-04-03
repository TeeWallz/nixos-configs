{ system, pkgs, ... }: {
  my = {
    boot = {
      inherit system;
      hostId = "e74b069c";
      devNodes = "/dev/disk/by-id/";
      bootDevices = [ "ata-QEMU_HARDDISK_QM00003" ];
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
    };
    networking.hostName = "saradomin";
    per-user.yc = {
      templates.desktop.enable = true;
      # custom keyboard layout
      modules.keyboard.enable = true;
    };
  };
}


































# { modulesPath, ... }: {
#   imports = [
#     (modulesPath + "/profiles/qemu-guest.nix")
#     # inputs.hardware.nixosModules.common-cpu-intel
#     # inputs.hardware.nixosModules.common-gpu-nvidia
#     # inputs.hardware.nixosModules.common-gpu-intel
#     # inputs.hardware.nixosModules.common-pc-ssd

#     ./hardware-configuration.nix

#     # ../common/global
#     # ../common/users/misterio

#     # ../common/optional/wireless.nix
#     # ../common/optional/greetd.nix
#     # ../common/optional/pipewire.nix
#   ];

#   nixpkgs.hostPlatform.system = "aarch64-linux";
# }

