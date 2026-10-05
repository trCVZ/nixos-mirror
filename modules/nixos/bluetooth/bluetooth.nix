{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.bluetooth;
in
{
  options.my.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth configuration";

    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Blueman GUI";
    };

    powerOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Power on Bluetooth at boot";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.powerOnBoot;
    };

    services.blueman.enable = cfg.enableGui;
  };
}
