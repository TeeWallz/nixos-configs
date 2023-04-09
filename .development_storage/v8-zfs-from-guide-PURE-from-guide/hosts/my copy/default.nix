{ inputs, lib, home-manager, ... }: {
  # HERE
  lib = import ./lib.nix { inherit inputs lib home-manager; };
}
