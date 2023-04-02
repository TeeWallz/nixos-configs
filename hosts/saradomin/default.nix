{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-gpu-nvidia
    # inputs.hardware.nixosModules.common-gpu-intel
    # inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    # ../common/global
    # ../common/users/misterio

    # ../common/optional/wireless.nix
    # ../common/optional/greetd.nix
    # ../common/optional/pipewire.nix
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
