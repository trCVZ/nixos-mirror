{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.docker;
in
{
  options.my.docker = {
    enable = lib.mkEnableOption "Docker virtualization stack";

    rootless = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable rootless Docker mode (runs daemon as non-root user)";
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users added to the docker group";
    };

    dns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      description = "DNS servers used by Docker daemon";
    };

    registryMirrors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "https://mirror.gcr.io" ];
      description = "Docker registry mirrors";
    };

    storageDriver = lib.mkOption {
      type = lib.types.str;
      default = "overlay2";
      description = "Docker storage driver";
    };

    logDriver = lib.mkOption {
      type = lib.types.str;
      default = "journald";
      description = "Docker log driver";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;

      daemon.settings = {
        dns = cfg.dns;
        registry-mirrors = cfg.registryMirrors;
        storage-driver = cfg.storageDriver;
        log-driver = cfg.logDriver;
      };

      rootless = {
        enable = cfg.rootless;
        setSocketVariable = true;
      };
    };

    users.users = lib.mkIf (cfg.users != [ ]) (
      lib.genAttrs cfg.users (_: {
        extraGroups = [ "docker" ];
      })
    );
  };
}
