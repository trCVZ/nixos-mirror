{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Audio
  my.audioPipewire = {
    enable = true;
    enableGui = true;
  };

  # Bluetooth
  my.bluetooth = {
    enable = true;
    enableGui = true;
    powerOnBoot = false;
  };

  # Boot
  my.boot = {
    profile = "uefi";
    silent = true;
    hardened = true;
    timeout = 15;
  };

  # Desktop
  my.hyprland = {
    enable = true;

    xwayland = true;
    withUWSM = false;
  };

  my.ttySessionSelector.enable = true;

  my.systemPackages = {
    enable = true;
    allowUnfree = true;
  };

  # Hardware
  my.cpu = {
    enable = true;
    type = "amd";

    cpupower = {
      enable = true;
      gui = true;
    };

    autoCpufreq.enable = false;
    thermald.enable = false;
  };

  my.gpu = {
    enable = true;
    type = "amd";
    enable32bit = true;
    lact = true;
  };

  my.camera = {
    # Enable service
    enable = true;
    # Disable Camera
    disable = true;
  };

  my.openrazer = {
    enable = true;
    users = [ "trcvz" ];
    enableGui = true;
  };

  # Networking
  my.networking = {
    enable = true;
    hostname = "laptop";
    users = [ "trcvz" ];
  };

  # SSH
  my.ssh = {
    enable = true;
    port = 22;
    allowUsers = [ "trcvz" ];
    permitRootLogin = "no";
    passwordAuthentication = false;
    agent = true;
  };

  # Security
  my.kernelHardening = {
    enable = true;
  };

  # PAM
  my.pamHardening = {
    enable = true;

    services = [
      "login"
      "sshd"
      "sudo"
      "su"
    ];

    passwordQuality = {
      enable = true;
      minLength = 16;
      minClasses = 0;
      difok = 0;
      maxRepeat = 3;
      maxClassRepeat = 0;
      dictCheck = false;
      userCheck = true;
      enforceForRoot = true;
      retry = 3;
    };

    passwordHashing = {
      algorithm = "yescrypt";
      rounds = null;
    };

    faillock = {
      enable = true;
      deny = 5;
      unlockTime = 60;
      failInterval = 60;
      evenDenyRoot = true;
      dir = "/var/lib/faillock";
    };

    loginDefs = {
      enable = true;
      umask = "027";
      passwordAging.enable = false;
      loginRetries = 5;
      loginTimeout = 60;
    };

    maxLogins = 10;
    disableCoreDumps = true;
    auditd.enable = false;
  };

  # Virtualisation
  my.docker = {
    enable = true;
    rootless = true;
    users = [ "trcvz" ];
  };

  my.virtualisation = {
    # Disabled to improve boot time
    enable = false;
    enableGui = true;
    users = [ "trcvz" ];
  };

  # XDG Standards for nix folders
  my.xdg.enable = true;

  # ------------------------------------

  programs.nix-ld.enable = true;
  # services.flatpak.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "lat4-19";
    keyMap = "us";
    #  useXkbConfig = true; # use xkb.options in tty.
  };

  security.pam.services.hyprlock = { };

  users.users.trcvz = {
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };
  services.udisks2.enable = true;
  # Eviter ces warnings
  # Jul 19 21:16:45 laptop kernel: ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Index (0x000000032) is beyond end of object (length 0x32) (20250807/exo>
  # Jul 19 21:16:45 laptop kernel: ACPI Error: Aborting method \_SB.WMID.WQBZ due to previous error (AE_AML_BUFFER_LIMIT) (20250807/psparse-529)
  # Jul 19 21:16:45 laptop kernel: ACPI Error: Aborting method \_SB.WMID.WQBE due to previous error (AE_AML_BUFFER_LIMIT) (20250807/psparse-529)
  boot.blacklistedKernelModules = [
    "hp_bioscfg"
  ];
  services.upower.enable = true;
  # powerManagement.cpuFreqGovernor = "performance";
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  # Ne pas toucher a cette ligne
  system.stateVersion = "25.05";
}
