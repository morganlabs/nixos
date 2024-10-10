{
  home-manager,
  inputs,
  system,
  user,
  myLib,
  pkgs,
  ...
}:
with pkgs.lib;
with myLib;
home-manager.nixosModules.home-manager {
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
