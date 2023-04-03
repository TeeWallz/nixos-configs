{
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";

    # unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      lib = nixpkgs.lib;
      inherit (self) outputs;
      my = import ./my { inherit inputs home-manager lib; };
    in {
      nixosConfigurations = {
        # build but not install with
        # nix build ./#nixosConfigurations.exampleHost.config.system.build.toplevel
        # install to /mnt with
        # nixos-install --flake ./#exampleHost
        exampleHost = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in my.lib.mkHost (import ./hosts/exampleHost { inherit system pkgs; });

        saradomin = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in my.lib.mkHost (import ./hosts/saradomin { inherit system pkgs; });

        guthix = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in my.lib.mkHost (import ./hosts/guthix { inherit system pkgs; });

        # build with
        # nix build .#nixosConfigurations.live-iso.config.system.build.isoImage
        live-iso = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in lib.nixosSystem {
          inherit system pkgs;
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];
        };

        qinghe = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in my.lib.mkHost (import ./hosts/qinghe { inherit system pkgs; });

        tieling = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in my.lib.mkHost (import ./hosts/tieling { inherit system pkgs; });

        yinzhou = let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in my.lib.mkHost (import ./hosts/yinzhou { inherit system pkgs; });
      };
    };
}
