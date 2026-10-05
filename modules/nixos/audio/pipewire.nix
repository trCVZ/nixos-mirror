{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.audioPipewire;
in
{
  options.my.audioPipewire = {

    enable = lib.mkEnableOption "PipeWire audio configuration";

    alsa = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ALSA support (legacy application compatibility)";
    };

    pulse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable PulseAudio emulation layer";
    };

    jack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable JACK support (pro audio / low latency use cases)";
    };

    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install GUI tools for PipeWire (pavucontrol)";
    };
  };

  config = lib.mkIf cfg.enable {

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = cfg.alsa;
      alsa.support32Bit = cfg.alsa;
      pulse.enable = cfg.pulse;
      jack.enable = cfg.jack;
      wireplumber.enable = true;
    };

    environment.systemPackages = lib.optionals cfg.enableGui [
      pkgs.pavucontrol
    ];
  };
}
