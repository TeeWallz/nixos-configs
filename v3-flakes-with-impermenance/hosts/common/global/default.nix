# This file (and the global directory) holds config that i use on all hosts
{ lib, inputs, outputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    # ./acme.nix
    # ./fish.nix
    ./locale.nix
    # ./tailscale.nix
    # ./nix.nix
    ./openssh.nix
    # ./podman.nix
    # ./postgres.nix
    # ./sops.nix
    # ./ssh-serve-store.nix
    # ./steam-hardware.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment = {
    persistence = {
      "/persist".directories = [ 
        "/var/lib/systemd"
        "/var/log"
        ];
    };
    enableAllTerminfo = true;
  };

  programs.fuse.userAllowOther = true;
  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}
