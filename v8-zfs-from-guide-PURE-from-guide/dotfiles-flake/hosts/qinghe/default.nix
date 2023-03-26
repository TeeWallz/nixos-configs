{ system, pkgs, ... }: {
  my = {
    boot = {
      inherit system;
      hostId = "abcd1234";
      bootDevices = [ "ata-TOSHIBA_Q300._46DB5111K1MU" ];
      availableKernelModules = [ "i915" ];
    };
    networking.hostName = "qinghe";
    per-user.yc = {
      templates.desktop.enable = true;
      # custom keyboard layout
      modules.keyboard.enable = true;
    };
  };
}
