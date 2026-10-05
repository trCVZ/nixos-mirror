{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.virtualisation;
in
{
  options.my.virtualisation = {
    enable = lib.mkEnableOption "KVM/libvirt virtualization stack";

    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable virt-manager GUI tool";
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users added to libvirt group";
    };

    qemuPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qemu_kvm;
      description = "QEMU package used by libvirt";
    };

    extraQemuConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        namespaces = []
      '';
      description = "Raw QEMU verbatim configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;

      qemu = {
        package = cfg.qemuPackage;
        verbatimConfig = cfg.extraQemuConfig;
      };
    };

    programs.virt-manager.enable = cfg.enableGui;

    users.users = lib.mkIf (cfg.users != [ ]) (
      lib.genAttrs cfg.users (_: {
        extraGroups = [ "libvirtd" ];
      })
    );
  };
}
