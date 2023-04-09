{ lib, config, ... }:
let
  hostname = config.networking.hostName;
  wipeScript = ''
    echo -n "Wipe root?"
    read host_to_deploy
    echo "Rolling back root ZFS dataset to blank snapshot"
    zfs rollback -r rpool/nixos/local/root@blank
  '';
  zfsRoot.partitionScheme = {
    biosBoot = "-part5";
    efiBoot = "-part1";
    swap = "-part4";
    bootPool = "-part2";
    rootPool = "-part3";
  };

  zfsRoot.devNodes = ''''; # MUST have trailing slash! /dev/disk/by-id/
  zfsRoot.mirroredEfi = "/boot/efis/";
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";

in {

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.postDeviceCommands = lib.mkBefore wipeScript;

  fileSystems = {
    "/boot" = {
      device = "bpool/nixos/root";
      fsType = "zfs";
      options = [ "X-mount.mkdir" ];
    };

    "/" = {
      device = "rpool/nixos/local/root";
      fsType = "zfs";
      options = [ "X-mount.mkdir" ];
    };

    "/nix" = {
      device = "rpool/nixos/local/nix";
      fsType = "zfs";
      options = [ "X-mount.mkdir" ];
    };

    "/persist" = {
      device = "rpool/nixos/persist";
      fsType = "zfs";
      options = [ "X-mount.mkdir" ];
    };

    # "/var/lib" = {
    #   device = "rpool/nixos/var/lib";
    #   fsType = "zfs";
    #   options = [ "X-mount.mkdir" ];
    # };

    # "/var/log" = {
    #   device = "rpool/nixos/var/log";
    #   fsType = "zfs";
    #   options = [ "X-mount.mkdir" ];
    # };
  } // (builtins.listToAttrs (map (diskName: {
    name = zfsRoot.mirroredEfi + diskName + zfsRoot.partitionScheme.efiBoot;
    value = {
      device = zfsRoot.devNodes + diskName + zfsRoot.partitionScheme.efiBoot;
      fsType = "vfat";
      options = [
        "x-systemd.idle-timeout=1min"
        "x-systemd.automount"
        "noauto"
        "nofail"
      ];
    };
  }) zfsRoot.bootDevices));

}
