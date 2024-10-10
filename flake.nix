{
  inputs = {
    # Base
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Customisation
    nix-colors.url = "github:misterio77/nix-colors";

    # Neovim Plugins
    nvim-plugin-scroll-eof = {
      url = "github:Aasim-A/scrollEOF.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let

      user = {
        username = "morgan";
        name = "Morgan Jones";
        email = "me@morganlabs.dev";
      };

      mkSystem =
        {
          hostname,
          system ? "x86_64-linux",
          includeBase ? true,
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = (import ./overlays.nix { inherit inputs; });
            config.allowUnfree = true;
          };

          myLib = import ./myLib/default.nix { inherit (pkgs) lib; };
        in
        with pkgs.lib;
        with myLib;
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit
              inputs
              system
              myLib
              user
              hostname
              ;
          };

          modules = [
            (mkIfList includeBase ./hosts/_base/configuration.nix)
            (./hosts + "/${hostname}/configuration.nix")

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit
                    inputs
                    system
                    user
                    myLib
                    ;
                };

                users.${user.username} = mkMerge [
                  (./hosts + "/${hostname}/home.nix")
                  (mkIfElse includeBase ./hosts/_base/home.nix "")
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        # Veins - Lil Peep
        # HP Laptop 14s-dq2512sa
        # Intel i5-1135G7
        # Intel Iris Xe
        # 256GB NVMe SSD
        # 16GB (2x8GB) DDR4-2666
        # Realtek RTL8821CE-M Wi-Fi and Bluetooth 4.2
        veins = mkSystem { hostname = "veins"; };
      };
    };
}
