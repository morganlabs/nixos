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
  cfg = config.modules.programs.waybar.modules.pulse;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.pulse = {
    enable = mkEnableOption "Enable programs.waybar.modules.pulse";
    position = mkStringOption "Where to put the module" "right";
    index = mkIntOption "What index to place this module" 3;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkOrder cfg.index [ "pulseaudio" ];

      pulseaudio = {
        format = mkForce "󰕾  {volume}%";
        format-muted = mkForce "󰝟";
        scroll-step = mkForce 5;

        on-click = mkForce "${pkgs.pavucontrol}/bin/pavucontrol";
      };
    };
  };
}
