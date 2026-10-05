{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.openrazer;
in
{
  options.my.openrazer = {
    enable = lib.mkEnableOption "OpenRazer support for Razer devices";

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users added to the openrazer group";
    };

    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install Polychromatic GUI for OpenRazer";
    };
  };

  config = lib.mkIf cfg.enable {

    hardware.openrazer.enable = true;
    hardware.openrazer.users = cfg.users;

    environment.systemPackages = [
      pkgs.openrazer-daemon
    ]
    ++ lib.optionals cfg.enableGui [
      pkgs.polychromatic
    ];
  };
}
