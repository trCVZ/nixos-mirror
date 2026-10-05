{
  config,
  lib,
  ...
}:

let
  cfg = config.my.xdg;
in
{
  options.my.xdg = {
    enable = lib.mkEnableOption "XDG user directories and base directories";

    userDirs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable XDG user directories.";
      };

      createDirectories = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create the XDG user directories automatically.";
      };

      setSessionVariables = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Set legacy XDG user directory session variables such as
          XDG_DOWNLOAD_DIR.
        '';
      };
    };

    localBinInPath = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Add ~/.local/bin to PATH.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;

      userDirs = {
        enable = cfg.userDirs.enable;
        createDirectories = cfg.userDirs.createDirectories;
        setSessionVariables = cfg.userDirs.setSessionVariables;
      };

      localBinInPath = cfg.localBinInPath;

      # Standard XDG MIME support on Linux.
      mime.enable = true;
    };
  };
}
