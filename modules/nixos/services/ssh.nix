{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.ssh;
in
{
  options.my.ssh = {
    enable = lib.mkEnableOption "Enable hardened OpenSSH configuration";

    port = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "SSH listening port";
    };

    allowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "trcvz" ];
      description = "Allowed SSH users";
    };

    permitRootLogin = lib.mkOption {
      type = lib.types.enum [
        "yes"
        "no"
        "prohibit-password"
      ];
      default = "no";
      description = "Root SSH login policy";
    };

    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable password authentication (not recommended)";
    };

    agent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH agent";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.ssh.startAgent = cfg.agent;

    services.openssh = {
      enable = true;

      ports = [ cfg.port ];

      enableRecommendedAlgorithms = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];

      settings = {
        PasswordAuthentication = cfg.passwordAuthentication;
        PermitRootLogin = cfg.permitRootLogin;
        KbdInteractiveAuthentication = false;

        X11Forwarding = false;

        AllowUsers = cfg.allowUsers;

        LogLevel = "VERBOSE";

        StreamLocalBindUnlink = "yes";
      };

      extraConfig = ''
        ClientAliveCountMax 2
        ClientAliveInterval 300

        AllowTcpForwarding no
        AllowAgentForwarding no
        MaxAuthTries 3
        MaxSessions 2
        TCPKeepAlive no
      '';
    };
  };
}
