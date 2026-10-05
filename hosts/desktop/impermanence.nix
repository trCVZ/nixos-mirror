{
  boot.initrd.systemd.enable = true;

  boot.initrd.systemd.services.rollback-root = {
    description = "Reset Btrfs root subvolume";

    wantedBy = [ "initrd.target" ];

    after = [
      "systemd-cryptsetup@cryptroot.service"
    ];

    before = [
      "sysroot.mount"
    ];

    unitConfig.DefaultDependencies = false;

    serviceConfig.Type = "oneshot";

    script = ''
      set -eu

      mkdir -p /btrfs_tmp

      mount -o subvolid=5 /dev/mapper/cryptroot /btrfs_tmp

      if [ -d /btrfs_tmp/root ]; then
        btrfs subvolume delete /btrfs_tmp/root
      fi

      btrfs subvolume create /btrfs_tmp/root

      umount /btrfs_tmp
    '';
  };
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/etc/ssh"
      "/var/lib/nixos"
      "/var/lib/systemd"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

}