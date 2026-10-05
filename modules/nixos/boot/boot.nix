{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.boot;
in
{
  options.my.boot = {

    profile = lib.mkOption {
      type = lib.types.enum [
        "uefi"
        "raspberry"
      ];
      default = "uefi";
      description = "Boot configuration profile depending on hardware type";
    };

    silent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable silent boot (reduce console output)";
    };

    hardened = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable kernel hardening parameters";
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Bootloader timeout in seconds";
    };
  };

  config = lib.mkMerge [

    (lib.mkIf (cfg.profile == "uefi") {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = cfg.timeout;
    })

    (lib.mkIf (cfg.profile == "raspberry") {
      boot.loader.generic-extlinux-compatible.enable = true;
      boot.loader.grub.enable = false;
      boot.loader.timeout = 5;
    })

    (lib.mkIf cfg.silent {
      boot.initrd.verbose = false;
      boot.consoleLogLevel = 0;
    })

    {
      boot.kernelParams = lib.mkMerge [
        (lib.mkIf cfg.silent [
          "quiet"
          "loglevel=0"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ])

        (lib.mkIf cfg.hardened [
          "mce=0"
          "lockdown=confidentiality"
          "slab_nomerge"
          "init_on_alloc=1"
          "init_on_free=1"
          "page_alloc.shuffle=1"
          "pti=on"
          "randomize_kstack_offset=1"
          "vsyscall=none"
          "debugfs=off"
          "oops=panic"
          "module.sig_enforce=1"
          "nowatchdog"
        ])
      ];
    }
  ];
}
