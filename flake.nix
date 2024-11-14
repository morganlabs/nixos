{
  description = "Morgan's System Configurations using Nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs: let
    mkSystem = import ./mkSystem inputs;
  in {
    nixosConfigurations = nixpkgs.lib.foldl' (a: b: a // b) {} [
      (mkSystem "satellites" "x86_64-linux" {})
    ];
  };
}
