{
  imports = [
    ./hardware-configuration.nix
    # ./services

    ../common/global
    ../common/users/tom
  ];

  networking = {
    hostName = "zamorak";
    useDHCP = true;
  };
  system.stateVersion = "22.05";
  # Slows down write operations considerably
  nix.settings.auto-optimise-store = false;

  boot.binfmt.emulatedSystems = [ "x86_64-linux" "i686-linux" ];
}

