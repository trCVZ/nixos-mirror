{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.hyprland;
in
{
  options.my.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";

    xwayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XWayland support.";
    };

    withUWSM = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Launch Hyprland with UWSM.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = cfg.xwayland;
      withUWSM = cfg.withUWSM;
    };

    services.xserver.enable = false;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
