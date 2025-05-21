{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.hypr.paper;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.hypr.paper = {
    enable = mkEnableOption "Enable desktop.hyprland.hypr.paper";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.hyprpaper.enable = mkForce true;
      services.hyprpaper.enable = mkForce true;
    };
  };
}
