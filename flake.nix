{
  description = "Morgan's System Configurations using Nix";

  inputs = {
    # Core
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Programs
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim Plugins
    nvim-plugin-scroll-eof = {
      url = "github:Aasim-A/scrollEOF.nvim";
      flake = false;
    };

    # Customisation
    stylix.url = "github:morganlabs-forks/stylix";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkSystem = import ./mkSystem inputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = nixpkgs.lib.foldl' (a: b: a // b) { } [
        (mkSystem "satellites" "x86_64-linux" "9866131b-c6ff-4473-a466-df2b602bce9c" { })
        (mkSystem "canals" "x86_64-linux" "ee252afe-bb5f-465d-a398-bf13dfbeb680" { })
      ];
    };
}
