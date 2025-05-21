{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.waybar.modules.battery;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.battery = {
    enable = mkEnableOption "Enable programs.waybar.modules.battery";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 1;

    bat = mkStringOption "Which battery to monitor" "BAT0";
    full_at = mkIntOption "What % the battery is limited to" 100;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "battery" ];

      battery = {
        inherit (cfg) full_at bat;
        format = mkForce "{icon} {capacity}%";
        format-icons = [
          "󰁺"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };
    };
  };
}
