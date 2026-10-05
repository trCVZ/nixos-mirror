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
    enable = lib.mkEnableOption "XDG base directories";

    nix = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Make Nix use XDG base directories.";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings."use-xdg-base-directories" = cfg.nix;
  };
}
