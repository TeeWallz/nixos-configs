{ config, lib, pkgs, ... }: with lib; { imports = [ ./desktop ./server ]; }
