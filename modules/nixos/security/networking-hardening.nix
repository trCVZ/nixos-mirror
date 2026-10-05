{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.networkingHardening;
in
{
  options.my.networkingHardening = {
    enable = lib.mkEnableOption "network security hardening";

    blockPing = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Block ICMP echo requests (ping)";
    };

    logDroppedPackets = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Log dropped firewall packets";
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall = {
      enable = true;

      allowPing = !cfg.blockPing;

      logRefusedPackets = cfg.logDroppedPackets;

    };

    networking.nftables.enable = true;
  };
}
