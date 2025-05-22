{
  description = "My NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-plugin-scroll-eof = {
      url = "github:Aasim-A/scrollEOF.nvim";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkSystem = import ./mkSystem inputs;
    in
    {
      formatter =
        let
          nixfmt = system: { "${system}" = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style; };
        in
        nixpkgs.lib.attrsets.mergeAttrsList [
          (nixfmt "x86_64-linux")
          (nixfmt "aarch64-linux")
          (nixfmt "x86_64-darwin")
          (nixfmt "aarch64-darwin")
        ];

      nixosConfigurations = nixpkgs.lib.attrsets.mergeAttrsList [
        (mkSystem "Earth" "Morgan's Laptop" "x86_64-linux")
        (mkSystem "Jupiter" "Morgan's Gaming Computer" "x86_64-linux")
      ];
    };
}
