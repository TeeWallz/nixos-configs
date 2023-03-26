{ config, lib, ... }:
with lib;

let cfg = config.my.networking;
in {
  options.my.networking = {
    networkmanager = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      wirelessNetworks = mkOption {
        description = "configure wireless networks with NetworkManager";
        type = with types; attrsOf str;
        default = { };
        example = { "network_ssid" = "password"; };
      };
    };
    hostName = mkOption {
      description = "The name of the machine.  Used by nix flake.";
      type = types.str;
      default = "exampleHost";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
  };
  config = {
    services.openssh = {
      enable = mkDefault true;
      # settings = { PasswordAuthentication = mkDefault false; };
      passwordAuthentication = mkDefault false;
    };
    environment.etc = (mkIf cfg.networkmanager.enable (mkMerge (mapAttrsToList
      (name: pwd: {
        "NetworkManager/system-connections/${name}.nmconnection" = {
          # networkmanager demands secure permission
          mode = "0600";
          text = ''
            [connection]
            id=${name}
            type=wifi

            [wifi]
            mode=infrastructure
            ssid=${name}

            [wifi-security]
            auth-alg=open
            key-mgmt=wpa-psk
            psk=${pwd}
          '';
        };
      }) cfg.networkmanager.wirelessNetworks)));
    time.timeZone = cfg.timeZone;
    networking = {
      networkmanager = {
        enable = cfg.networkmanager.enable;
        wifi = { macAddress = mkDefault "random"; };
      };
      firewall.enable = mkDefault true;
      hostName = cfg.hostName;
    };
  };
}
