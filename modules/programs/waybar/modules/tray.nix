{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.waybar.modules.tray;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.tray = {
    enable = mkEnableOption "Enable programs.waybar.modules.tray";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 0;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "tray" ];
    };
  };
}
