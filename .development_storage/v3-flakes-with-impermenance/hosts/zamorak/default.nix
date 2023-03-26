{
  imports = [
    # ./services
    ./hardware-configuration.nix

    
    ../common/global
    ../common/users/tom

    ../common/optional/systemd-boot.nix
    ../common/optional/pipewire.nix
  ];

  networking = {
    hostName = "zamorak";
    useDHCP = false;
    interfaces.enp1s0 = {
      useDHCP = true;

      ipv4 = {
        addresses = [{
          address = "192.168.1.60";
          prefixLength = 24;
        }];
      };
    };

    programs = { kdeconnect.enable = true; };

  };
  system.stateVersion = "22.05";
}
