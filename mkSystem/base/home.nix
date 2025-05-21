{ inputs, vars, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs vars; };

    users.${vars.user.username} = {
      imports = [ (../../hosts + "/${vars.hostname}/home.nix") ];

      home.file.".face".source = ./face.jpg;
    };
  };
}
