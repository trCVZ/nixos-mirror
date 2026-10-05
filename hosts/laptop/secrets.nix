{ ... }:

{
  #   sops = {
  #     secrets = {

  #       "secret_name" = {
  #         sopsFile = ../../secrets/hosts/laptop.yaml;

  #         owner = "root";
  #         group = "root";
  #         mode = "0400";
  #       };

  #     };
  #   };
}
