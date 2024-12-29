inputs:
with inputs;
let
  mkSystem =
    hostname: system:
    let
      vars = import ../vars.nix;
      baseConfig = import ./baseConfig.nix { inherit system; };
      homeManagerConfig = import ./homeManagerConfig.nix hostname;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      myLib = import ../lib {
        inherit (pkgs) lib;
        inherit pkgs inputs;
      };

      lib = pkgs.lib.extend (_: prev: home-manager.lib // prev // myLib);
    in
    {
      "${hostname}" = nix-darwin.lib.darwinSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs vars lib;
        };

        modules = [
          (../hosts + "/${hostname}/configuration.nix")
          ../modules/darwin
          baseConfig
          homeManagerConfig
        ];
      };
    };
in
mkSystem

