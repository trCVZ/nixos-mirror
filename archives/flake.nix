{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations.node-1 = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          {
            nixpkgs.buildPlatform.system = "x86_64-linux";
            nixpkgs.hostPlatform.system = "aarch64-linux";
          }
        ];
      };
    };
}
