{ modulesPath, ... }:
{
  imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
  ];


  nixpkgs.hostPlatform.system = "aarch64-linux";
}