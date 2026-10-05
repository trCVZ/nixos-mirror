{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.networking;
in
{
  options.my.networking = {
    enable = lib.mkEnableOption "base networking configuration";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "laptop";
      description = "Hostname of the machine";
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users added to the networkmanager group";
    };
  };

  config = lib.mkIf cfg.enable {

    networking.hostName = cfg.hostname;

    networking.nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];

    networking.networkmanager = {
      enable = true;

      wifi.backend = "iwd";

      ensureProfiles = {
        environmentFiles = [
          config.sops.secrets."wifi_env".path
        ];

        profiles = {

          "home-wifi" = {
            connection = {
              id = "$network_home_ssid";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "$network_home_ssid";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$network_home_psk";
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
            proxy = { };
          };

          "holyday-wifi" = {
            connection = {
              id = "$network_holyday_ssid";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "$network_holyday_ssid";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$network_holyday_psk";
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
            proxy = { };
          };

          "phone-wifi" = {
            connection = {
              id = "$network_phone_ssid";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "$network_phone_ssid";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$network_phone_psk";
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
            proxy = { };
          };
        };
      };
    };

    users.users = lib.mkIf (cfg.users != [ ]) (
      lib.genAttrs cfg.users (_: {
        extraGroups = [ "networkmanager" ];
      })
    );
  };
}
