{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./k3s.nix
  ];

  # Boot
  my.boot = {
    profile = "raspberry";
    silent = true;
    hardened = true;
    timeout = 5;
  };

  # Networking
  my.networking = {
    enable = true;
    hostname = "node-1";
    users = [ "admin" ];
  };

  # SSH
  my.ssh = {
    enable = true;
    port = 22;
    allowUsers = [ "admin" ];
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
    # FIX: Set to false now but will change later
    enable = false;
  };

  # XDG Standards for nix folders
  my.xdg.enable = true;

  # ------------------------------------

  hardware.enableRedistributableFirmware = true;
  nix.settings.require-sigs = false;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "us";
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = config.sops.secrets."admin_initial_password".path;
  };
  services.openssh.authorizedKeysFiles = [
    config.sops.secrets."ssh/authorized_keys/trcvz@laptop".path
  ];
  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "26.05"; # Dont  delete or modify
}
