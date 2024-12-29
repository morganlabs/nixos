inputs:
with inputs;
let
  mkSystem =
    hostname: system: luksDevice:
    let
      vars = import ../vars.nix;
      overlays = import ../overlays.nix inputs;
      baseConfig = import ./baseConfig.nix { inherit hostname luksDevice; };
      homeManagerConfig = import ./homeManagerConfig.nix hostname;

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      myLib = import ../lib {
        inherit (pkgs) lib;
        inherit pkgs inputs;
      };

      lib = pkgs.lib.extend (_: prev: home-manager.lib // prev // myLib);
    in
    {
      "${hostname}" = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs vars lib;
        };

        modules = [
          (../hosts + "/${hostname}/configuration.nix")
          ../modules/nixos
          baseConfig
          homeManagerConfig
        ];
      };
    };
in
mkSystem
