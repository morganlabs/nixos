{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim Plugins
    plugin-scroll-eof-nvim = {
      url = "github:Aasim-A/scrollEOF.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, nur, ... }@inputs:
  let
    lib = nixpkgs.lib;

    user = {
      username = "morgan";
      name = "Morgan Jones";
      email = "me@morganlabs.dev";
    };

    mkSystem = { hostname, system ? "x86_64-linux", }:
    let
      overlays = [
        nur.overlay
        (_: prev: {
          vimPlugins = prev.vimPlugins // {
            scroll-eof-nvim = prev.vimUtils.buildVimPlugin {
              name = "scroll-eof-nvim";
              src = inputs.plugin-scroll-eof-nvim;
            };
          };
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

    in lib.nixosSystem {
        inherit system pkgs;

        specialArgs = {
          inherit inputs system user;
        };

        modules = [
          (./hosts + "/${hostname}/configuration.nix")
          ({ ... }:
           {
	     environment.systemPackages = with pkgs; [ git ];
             networking.hostName = hostname;
             nix.registry.nixpkgs.flake = nixpkgs;
           })

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs system user;
                };

                users.${user.username} = lib.mkMerge [
                  (./hosts + "/${hostname}/home.nix")
                  ({ ... }: {
                     imports = [ ./roles/home ];
                     roles.git.enable = lib.mkDefault true;
                  })
                ];
              };
            }
         ];
       };
  in {
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
