{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.dbus.implementation = "broker";
  security.sudo.execWheelOnly = true;
}
