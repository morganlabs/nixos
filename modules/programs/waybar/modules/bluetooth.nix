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
  cfg = config.modules.programs.waybar.modules.bluetooth;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.bluetooth = {
    enable = mkEnableOption "Enable programs.waybar.modules.bluetooth";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 5;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "bluetooth" ];

      bluetooth = {
        format = mkForce "󰂳 ";
        format-on = mkForce "󰂯 ";
        format-connected = mkForce "󰂱 ";
        format-disabled = mkForce "󰂲 ";
        format-off = mkForce "󰂲 ";

        on-click = mkForce "${pkgs.blueman}/bin/blueman-manager";
      };
    };
  };
}
