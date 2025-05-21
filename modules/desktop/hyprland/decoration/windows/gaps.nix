{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.decoration.windows.gaps;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.decoration.windows.gaps = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.decoration.windows.gaps";

    regular = {
      inner = mkIntOption "How many px of gaps to have between windows in regular workspaces" 5;
      outer = mkIntOption "How many px of gaps to have between windows and edge of workspace in regular workspaces" 10;
    };

    special = {
      inner = mkIntOption "How many px of gaps to have between windows in special workspaces" 5;
      outer = mkIntOption "How many px of gaps to have between windows and edge of workspace in special workspaces" 40;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings = {
      general = {
        gaps_in = mkForce cfg.regular.inner;
        gaps_out = mkForce cfg.regular.outer;
      };

      workspace = mkAfter [
        "s[true], gapsout:${toString cfg.special.outer}, gapsin:${toString cfg.special.inner}"
        "f[true], gapsout:0"
      ];
    };
  };
}
