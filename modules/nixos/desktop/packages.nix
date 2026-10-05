{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.systemPackages;
in
{
  options.my.systemPackages = {
    enable = lib.mkEnableOption "common system packages";

    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow unfree packages in Nixpkgs.";
    };

  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = cfg.allowUnfree;

    environment.systemPackages = with pkgs; [
      # System / administration
      home-manager
      lynis

      # Hardware / laptop
      brightnessctl

      # Editors
      vim

      # Network / downloads
      bind
      wget

      # Secrets / encryption
      sops
      age
    ];

  };
}
