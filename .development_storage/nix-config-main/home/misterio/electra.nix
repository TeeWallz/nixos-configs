{ inputs, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/wireless
    ./features/desktop/hyprland
    ./features/pass
  ];

  wallpaper = (import ./wallpapers).forest-deer-landscape;
  colorscheme = inputs.nix-colors.colorschemes.silk-dark;

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      hasBar = true;
      workspace = "1";
      x = 0;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      hasBar = true;
      workspace = "2";
      x = 1920;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      workspace = "3";
      x = 3840;
    }
  ];
}
