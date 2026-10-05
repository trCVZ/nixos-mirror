{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFormat = "yaml";
    validateSopsFiles = true;

    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };

    secrets = {
      wifi_env = {
        sopsFile = ../../../secrets/hosts/shared.yaml;

        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
}
