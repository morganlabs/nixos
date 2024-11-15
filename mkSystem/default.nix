inputs:
with inputs; let
  mkSystem = hostname: system: luksDevice: {}: let
    vars = import ../vars.nix;
    baseConfig = import ./baseConfig.nix { inherit hostname luksDevice; };
    homeManagerConfig = import ./homeManagerConfig.nix;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    "${hostname}" = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = { inherit inputs vars; };
      
      modules = [
        (../hosts + "/${hostname}/configuration.nix")
	../nixosModules
        baseConfig
	homeManagerConfig
      ];
    };
  };
in mkSystem
