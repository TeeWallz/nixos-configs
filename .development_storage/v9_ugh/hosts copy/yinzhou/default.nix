{ system, pkgs, ... }: {
  my = {
    boot = {
      inherit system;
      hostId = "e74b069d";
      bootDevices = [ "nvme-SAMSUNG_MZVLV256HCHP-000H1_S2CSNA0J547878" ];
    };
    networking.hostName = "yinzhou";
    per-user.yc = {
      templates.desktop.enable = true;
      # custom keyboard layout
      modules.keyboard.enable = true;
    };
  };
}
