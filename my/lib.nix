{ inputs, lib, home-manager, ... }: {
  mkHost = { my }:
    let
      system = my.boot.system;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in lib.nixosSystem {
      inherit system;
      modules = [
        # HERE
        # BOOT STUFF IMPORTED HERE!!
        ../modules
        (import ../configuration.nix { inherit my inputs pkgs lib; })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
