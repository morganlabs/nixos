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
  cfg = config.modules.desktop.hyprland.autostart.zen-browser;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.autostart.zen-browser = {
    enable = mkEnableOption "Enable desktop.hyprland.autostart.zen-browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once =
      mkAfter
        [
          "[workspace 2] ${inputs.zen-browser.packages."${pkgs.system}".default}/bin/zen"
        ];
  };
}
