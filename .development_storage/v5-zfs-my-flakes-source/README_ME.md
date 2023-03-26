nix-shell -p gitMinimal nano

cd /tmp
git clone https://github.com/TeeWallz/dotfiles-flake.git
cd /tmp/dotfiles-flake

nixos-install --flake .#zamorak