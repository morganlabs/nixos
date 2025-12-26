inputs: hostname: prettyName: system: sshKey:
let
  vars = import ./vars.nix // {
    inherit
      hostname
      prettyName
      sshKey
      system
      ;
  };
  overlays = import ./overlays.nix inputs;

  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  myLib = import ../lib pkgs.lib;

  lib = pkgs.lib.extend (_: prev: prev // myLib);
in
{
  "${hostname}" = inputs.nixpkgs.lib.nixosSystem {
    inherit system pkgs;

    specialArgs = { inherit vars lib inputs; };
    modules = [
      ../hosts/${hostname}/config.nix
      ../modules
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${vars.user.username} = {
            imports = [ (../hosts + "/${vars.hostname}/home.nix") ];
          };
        };
      }
    ];
  };
}
