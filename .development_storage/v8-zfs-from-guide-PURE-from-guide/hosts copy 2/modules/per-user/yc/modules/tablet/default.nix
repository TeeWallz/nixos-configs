{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.per-user.yc.modules.tablet;
in {
  options.my.per-user.yc.modules.tablet.enable = mkOption {
    type = types.bool;
    default = config.my.per-user.yc.enable;
  };
  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ xournalpp ]; };
}
