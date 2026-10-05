{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./packages.nix
    ./programs.nix
  ];

  # ─────────────────────────────────────────────
  # Home Manager
  # ─────────────────────────────────────────────

  home.username = "trcvz";
  home.homeDirectory = "/home/trcvz";
  home.stateVersion = "25.05";

  # ─────────────────────────────────────────────
  # Fonts
  # ─────────────────────────────────────────────

  fonts.fontconfig.enable = true;

  # ─────────────────────────────────────────────
  # Environment
  # ─────────────────────────────────────────────

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    KUBECONFIG = "${config.xdg.configHome}/kube/config";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
  };

  # ─────────────────────────────────────────────
  # Git
  # ─────────────────────────────────────────────

  programs.git = {
    enable = true;

    settings = {
      user.name = "trcvz";
      user.email = "tristan.cvz.pro@gmail.com";
    };
  };

  # ─────────────────────────────────────────────
  # SSH
  # ─────────────────────────────────────────────

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "node-1" = {
        HostName = "192.168.1.100";
        User = "admin";

        IdentityFile = "~/.ssh/ssh_trcvz_ed25519_key";
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
        HashKnownHosts = true;
      };

      "github.com" = {
        HostName = "github.com";
        User = "git";

        IdentityFile = "~/.ssh/ssh_trcvz_ed25519_key";
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
        HashKnownHosts = true;
      };
    };
  };

  # ─────────────────────────────────────────────
  # XDG
  # ─────────────────────────────────────────────

  my.xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;
    };

    localBinInPath = false;
  };

  # ─────────────────────────────────────────────
  # Kubernetes directories
  # ─────────────────────────────────────────────

  home.activation.createKubeDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p \
      "${config.xdg.configHome}/kube" \
      "${config.xdg.cacheHome}/kube"
  '';
}
