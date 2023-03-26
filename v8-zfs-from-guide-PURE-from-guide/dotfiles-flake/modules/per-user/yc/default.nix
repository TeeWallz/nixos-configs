{ config, lib, pkgs, ... }:
with lib; {
  imports = [ ./modules ./templates ];
  options.my.per-user.yc.enable = mkOption {
    description = "enable yc options with desktop";
    type = with types; bool;
    default = false;
  };
  config =
    mkIf config.my.per-user.yc.enable { my.programs.sway.enable = true; };
}
