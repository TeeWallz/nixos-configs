# #
##
##  per-host configuration for exampleHost
##
##

{ system, pkgs, ... }: {
  my = {
    boot = {
      inherit system;
      devNodes = "/dev/disk/by-id/";
      bootDevices = [  "ata-QEMU_HARDDISK_QM00003" ];
      immutable = false;
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

      # enable ssh remote unlock steps:
      #  BEGIN IMPORTANT:
      #  step: do this only after you have booted into the new NixOS installation.
      #        Reason: during installation /var/lib is not mounted.
      #  END   IMPORTANT.
      #
      #  step: check which kernel module is needed for networking with:
      #          nix-shell -p pciutils
      #          lspci -v | grep -iA8 'network\|ethernet'
      #  step: add that module to availableKernelModules above
      #  step: DHCP is used for networking by default.
      #  step: if manual configuration is needed,
      #        configure with kernelParams:
      #        see https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
      #        "ip=" option.
      #  step: generate host key:
      #          ssh-keygen -t ed25519 -N "" -f "/var/lib/ssh_unlock_zfs_ed25519_key"
      #          ssh-keygen -t rsa -N "" -f "/var/lib/ssh_unlock_zfs_rsa_key"
      #  step: put your public key inside sshUnlock.authorizedKeys
      #  step: enable sshUnlock.enable and nixos-rebuild boot
      #  step: because the host key in new, delete existing SSH key fingerprint with
      #         ssh-keygen -R $IP_ADDR
      kernelParams = [ ];
      sshUnlock = {
        enable = false;
        authorizedKeys = [ ];
      };
    };

    users = {
      root = {
        # generate hash with:
        # mkpasswd -m SHA-512 -s
        # set hash to "!" to disable login
        initialHashedPassword = "$6$1RZ.G8.qPCbULb4C$iBxWO83NN9jAQHgYWYhU6H9FQqFbNfboL5IY5sj.PSWlYGfdx588ashgL35Wl0zQMUSjxuP7y7Hy7fsLiYPt11";

        authorizedKeys = [ "sshKey_placeholder" ];
        isSystemUser = true;
      };

      tom = {
        initialHashedPassword = "$6$1RZ.G8.qPCbULb4C$iBxWO83NN9jAQHgYWYhU6H9FQqFbNfboL5IY5sj.PSWlYGfdx588ashgL35Wl0zQMUSjxuP7y7Hy7fsLiYPt11";
        description = "J. Magoo";
        extraGroups = [ "wheel" ];
        packages = with pkgs; [ mg ];
        isNormalUser = true;
      };
    };
    networking = {
      # also update host name in $REPO/flake.nix
      # and update import path to $REPO/hosts/myHostName
      hostName = "saradomin";
      timeZone = "Europe/Warsaw";
      # whether to use NetworkManager to manage networking
      # will pull in GTK4 on a headless system ~700MB
      # disable to use DHCP only
      networkmanager = {
        enable = true;
        wirelessNetworks = { "myWifi" = "myPass"; };
      };
    };

    # enable sway, a tiling Wayland window manager
    # Usage:
    #   Step: change "false" to "true".
    #   Step: add a normal user, see above.
    #   Step: generate and set password hash for the new user.
    #   Step: apply configuration, then reboot.
    #   Step: after reboot, at text console, login as normal user.
    #   Step: enter "sway" command then press "Return".
    programs = { sway.enable = false; };
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

