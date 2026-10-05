{ ... }:

{
  sops.secrets = {
    "ssh/authorized_keys/trcvz@laptop" = {
      sopsFile = ../../secrets/hosts/raspi3b.yaml;

      owner = "root";
      group = "root";
      mode = "0444";
    };

    "admin_initial_password" = {
      sopsFile = ../../secrets/hosts/raspi3b.yaml;

      owner = "root";
      group = "root";
      mode = "0444";
    };
  };
}
