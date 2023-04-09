{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./emacs
    ./firefox
    ./tex
    ./tablet
    ./virt
    ./keyboard
    ./hidden
    ./home-manager
    ./tmux
  ];
}
