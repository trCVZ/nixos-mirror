{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.gpu;
in
{
  options.my.gpu = {
    enable = lib.mkEnableOption "GPU configuration (AMD or NVIDIA)";

    type = lib.mkOption {
      type = lib.types.enum [
        "amd"
        "nvidia"
      ];
      default = "amd";
      description = "GPU driver type (AMD or NVIDIA)";
    };

    enable32bit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable 32-bit graphics support (Steam/Wine)";
    };

    nvidiaOpen = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use NVIDIA open kernel modules (recommended for modern GPUs)";
    };

    lact = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable LACT GPU control daemon";
    };
  };

  config = lib.mkIf cfg.enable (

    lib.mkMerge [

      (lib.mkIf (cfg.type == "amd") {
        hardware.graphics = {
          enable = true;
          enable32Bit = cfg.enable32bit;
        };

        services.lact.enable = cfg.lact;
      })

      (lib.mkIf (cfg.type == "nvidia") {
        hardware.graphics = {
          enable = true;
          enable32Bit = cfg.enable32bit;
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          modesetting.enable = true;
          open = cfg.nvidiaOpen;
          nvidiaSettings = true;
        };
      })

    ]
  );
}
