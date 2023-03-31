{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.per-user.yc.modules.virt;
in {
  options.my.per-user.yc.modules.virt.enable = mkOption {
    type = types.bool;
    default = config.my.per-user.yc.enable;
  };
  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
      };
    };
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
