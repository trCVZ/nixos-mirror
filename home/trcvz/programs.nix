{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./programs/hyprland.nix
    # ./programs/libreoffice.nix
  ];
}
