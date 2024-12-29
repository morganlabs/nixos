hostname:
{
  inputs,
  vars,
  lib,
  ...
}:
with lib;
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs vars;
    };

    users.${vars.user.username} = {
      home.homeDirectory = "/Users/${vars.user.username}";

      imports = with inputs; [
        (../hosts + "/${hostname}/home.nix")
      ];
    };
  };
}
