{
  description = "Morgan's NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    jellarr.url = "github:venkyr77/jellarr";
    agenix-template.url = "github:jhillyerd/agenix-template/1.0.0";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
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

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkSystem = import ./mkSystem inputs;
    in
    {
      nixosConfigurations = nixpkgs.lib.attrsets.mergeAttrsList [
        (mkSystem "Mending" "Morgan's Laptop" "x86_64-linux"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGrz9BTF/SPv3/ioaUv6pMt13pPz6w3qOZA2C8+cdlS"
        )

        # SERVERS
        (mkSystem "Unbreaking" "Unbreaking Server" "x86_64-linux"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMXQPOLNAnJXnn4HXkd0fZBwhoc1PIQNdXS7Pq6vuIg"
        )
      ];
    };
}
