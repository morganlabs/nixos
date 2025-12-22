{
  description = "Morgan's NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs: let
    mkSystem = import ./mkSystem inputs;
  in {
    nixosConfigurations = nixpkgs.lib.attrsets.mergeAttrsList [
      (mkSystem "Mending" "Morgan's Laptop" "x86_64-linux" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGrz9BTF/SPv3/ioaUv6pMt13pPz6w3qOZA2C8+cdlS")
    ];
  };
}
