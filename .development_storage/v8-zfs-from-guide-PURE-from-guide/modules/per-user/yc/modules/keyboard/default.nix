{ config, lib, ... }:
with lib;
let cfg = config.my.per-user.yc.modules.keyboard;
in {
  options.my.per-user.yc.modules.keyboard.enable = mkOption {
    default = false;
    type = types.bool;
  };
  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "yc";
      extraLayouts."yc" = {
        description = "my layout";
        languages = [ "eng" ];
        symbolsFile = ./symbols.txt;
      };
    };
    environment.variables = { XKB_DEFAULT_LAYOUT = "yc"; };
  };
}
