{ config, lib, ... }:

let
  cfg = config.my.camera;
in
{
  options.my.camera = {
    enable = lib.mkEnableOption "camera support";

    disable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable webcam kernel modules (privacy/security)";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.blacklistedKernelModules = lib.optionals cfg.disable [
      "uvcvideo"
      "vivid"
    ];
  };
}
