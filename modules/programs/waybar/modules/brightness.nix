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
  cfg = config.modules.programs.waybar.modules.brightness;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.brightness = {
    enable = mkEnableOption "Enable programs.waybar.modules.brightness";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 2;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "backlight" ];

      backlight = {
        format = mkForce "{icon}  {percent}%";
        format-icons = [
          "󰃚"
          "󰃛"
          "󰃜"
          "󰃝"
          "󰃞"
          "󰃟"
          "󰃠"
        ];
      };
    };
  };
}
