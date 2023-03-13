{ lib, config, ... }:
let
  hostname = config.networking.hostName;
  wipeScript = ''
    echo -n "Wipe root?"
    read host_to_deploy
    echo "Rolling back root ZFS dataset to blank snapshot"
    zfs rollback -r rpool/nixos/local/root@blank
  '';
  impermanence = builtins.fetchTarball
    "https://github.com/nix-community/impermanence/archive/master.tar.gz";

in {

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.postDeviceCommands = lib.mkBefore wipeScript;

  fileSystems = {
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
  };
}
