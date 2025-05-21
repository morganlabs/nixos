{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.spotify;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.spotify = {
    enable = mkEnableOption "Enable programs.spotify";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      imports = [ inputs.spicetify-nix.homeManagerModules.default ];
      stylix.targets.spicetify.enable = mkForce true;

      programs.spicetify = {
        enable = mkForce true;
      };
    };
  };
}
