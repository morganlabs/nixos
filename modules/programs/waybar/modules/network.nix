{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.waybar.modules.network;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.network = {
    enable = mkEnableOption "Enable programs.waybar.modules.network";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 4;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "network" ];

      network = {
        interval = mkForce 10;

        tooltip-format = mkForce "{ifname}";
        tooltip-wifi = mkForce "{essid} | {ifname} | {signalStrength}";

        format = mkForce "NO FORMAT";
        format-ethernet = mkForce "󰈁";
        format-wifi = mkForce "{icon}  ";
        format-linked = mkForce "󰤠";
        format-disconnected = mkForce "󰤭";
        format-icons = mkForce [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
      };
    };
  };
}
