{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.cpu;
in
{
  options.my.cpu = {
    enable = lib.mkEnableOption "CPU configuration (AMD or Intel)";

    type = lib.mkOption {
      type = lib.types.enum [
        "amd"
        "intel"
      ];
      default = "amd";
      description = "CPU vendor (AMD or Intel)";
    };

    cpupower = {
      enable = lib.mkEnableOption "cpupower CPU frequency utilities";

      gui = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable cpupower-gui";
      };
    };

    autoCpufreq = {
      enable = lib.mkEnableOption "automatic CPU power/performance management with auto-cpufreq";
    };

    thermald = {
      enable = lib.mkEnableOption "thermald thermal management";
    };
  };

  config = lib.mkIf cfg.enable (

    lib.mkMerge [

      # ============================================================
      # cpupower
      # ============================================================

      (lib.mkIf cfg.cpupower.enable {
        environment.systemPackages = [
          pkgs.linuxPackages.cpupower
        ];
      })

      # ============================================================
      # cpupower-gui
      # ============================================================

      (lib.mkIf cfg.cpupower.gui {
        environment.systemPackages = [
          pkgs.cpupower-gui
        ];

        services.cpupower-gui.enable = true;
      })

      # ============================================================
      # auto-cpufreq
      # ============================================================

      (lib.mkIf cfg.autoCpufreq.enable {
        services.auto-cpufreq.enable = true;
      })

      # ============================================================
      # Intel
      # ============================================================

      (lib.mkIf (cfg.type == "intel") {
        services.thermald.enable = cfg.thermald.enable;
      })

    ]
  );
}
