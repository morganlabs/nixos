{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.waybar.modules.workspaces;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar.modules.workspaces = {
    enable = mkEnableOption "Enable programs.waybar.modules.workspaces";
    position = mkStringOption "Where to put the module" "left";
    compositor = mkStringOption "Which compositor is being used" "hyprland";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.waybar.settings.mainBar = {
      "modules-${cfg.position}" = mkBefore [ "${cfg.compositor}/workspaces" ];

      "${cfg.compositor}/workspaces" = mkForce {
        "persistent-workspaces" = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };
    };
  };
}
