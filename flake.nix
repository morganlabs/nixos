{
  description = "Morgan's System Configurations using Nix";

  inputs = {
    # Core
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Customisation
    stylix.url = "github:danth/stylix";
  };

  outputs = { nixpkgs, ... }@inputs: let
    mkSystem = import ./mkSystem inputs;
  in {
    nixosConfigurations = nixpkgs.lib.foldl' (a: b: a // b) {} [
      (mkSystem "satellites" "x86_64-linux" "9866131b-c6ff-4473-a466-df2b602bce9c" {})
    ];
  };
}
