{ config, pkgs, lib, ... }: {

  fileSystems."/" = { device = "rpool/nixos/local/root"; fsType = "zfs"; };
  fileSystems."/nix" = { device = "rpool/nixos/local/nix"; fsType = "zfs"; };
  # fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003"; fsType = "vfat"; };
  
boot = {
    # Imporved networking
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    kernel.sysctl."net.core.default_qdisc" = "fq";

    kernelParams = [ "quiet" "loglevel=3" ];
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 2;
    tmpOnTmpfs = lib.mkDefault true;

    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];

    kernelModules = [ "kvm-intel" ];
    zfs.devNodes = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003";
  };

  networking = {
    #firewall.enable = false;
    #firewall.allowedTCPPorts = [ 8080 9090 ];
    firewall.allowPing = false;
    hostId = builtins.substring 0 8
      (builtins.hashString "md5" config.networking.hostName);
    nameservers = [ "192.168.30.11" "192.168.30.12" ];
    useDHCP = false;
    networkmanager.enable = true;
  };

  programs.ssh.startAgent = true;

  services = {
    fwupd.enable = true;
    dbus.packages = with pkgs; [ dconf ];
    #zfs.autoSnapshot.enable = true;
    zfs.autoScrub.enable = true;
    openssh.enable = true;
    openssh.passwordAuthentication = false;
    printing.enable = true;
    tlp.enable = true;
  };
}
