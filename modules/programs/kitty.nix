{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.kitty;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.kitty = {
    enable = mkEnableOption "Enable programs.kitty";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.kitty.enable = mkForce true;
      programs.kitty = {
        enable = mkForce true;
        settings = {
          window_padding_width = mkForce 8;
          window_padding_height = mkForce 5;
          enable_audio_bell = mkForce false;
        };
      };
    };
  };
}
