{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.waybar.modules.clock;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.clock = {
    enable = mkEnableOption "Enable programs.waybar.modules.clock";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 6;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "clock" ];

      "clock" = mkForce {
        format = mkForce "{:%a %d %b  %H:%M}";
        interval = mkForce 5;
        tooltip = mkForce false;
      };
    };
  };
}
