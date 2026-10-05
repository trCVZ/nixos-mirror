{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.ttySessionSelector;
in
{
  options.my.ttySessionSelector = {
    enable = lib.mkEnableOption "TTY session selector";

    tty = lib.mkOption {
      type = lib.types.str;
      default = "/dev/tty1";
      description = "TTY on which the session selector should be shown.";
    };

    hyprland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Show Hyprland as a session option.";
    };

  };

  config = lib.mkIf cfg.enable {
    environment.etc."tty-session-selector.sh".text = ''
      #!/usr/bin/env bash

        # Run only on a real TTY with no graphical session already active.
        if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
            return 0
        fi

        if [ "$(tty 2>/dev/null)" != "${cfg.tty}" ]; then
            return 0
        fi

        while true; do
            echo ""
            echo "Select session:"
            ${lib.optionalString cfg.hyprland ''
              echo "  1) Hyprland"
            ''}
            echo "  2) Shell only (TTY)"

            read -r -p "Choice [1-2]: " SESSION_CHOICE

            case "$SESSION_CHOICE" in
              ${lib.optionalString cfg.hyprland ''
                1)
                    exec start-hyprland
                    ;;
              ''}
              2|"")
                return 0
                ;;
              *)
                echo "Invalid choice, please try again."
                ;;
            esac
        done
    '';

    environment.loginShellInit = ''
      if [ -r /etc/tty-session-selector.sh ]; then
          . /etc/tty-session-selector.sh
      fi
    '';

  };
}
