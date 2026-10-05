{ config, pkgs, ... }:

# Deprecated, encryption is done via disko 

{
  boot.initrd.availableKernelModules = [
    "aesni_amd"
    "cryptd"
  ];

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/device/nvme0n1p3";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.initrd.lvm = {
    enable = true;
    volumeGroups = {
      lvmroot = {
        devices = [ "/dev/mapper/cryptroot" ];
        volumes = {
          swap = {
            size = "4GiB";
          };
          root = {
            size = "100%FREE";
          };
        };
      };
    };
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fstype = "vfat";
  };

  fileSystems."/mnt" = {
    device = "/dev/mapper/lvm-root";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/mapper/lvmroot-swap"; }
  ];
}
