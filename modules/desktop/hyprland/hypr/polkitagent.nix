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
  cfg = config.modules.desktop.hyprland.hypr.polkitagent;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.hypr.polkitagent = {
    enable = mkEnableOption "Enable desktop.hyprland.hypr.polkitagent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprpolkitagent ];
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec = mkBefore [
      "systemctl --user start hyprpolkitagent"
    ];
  };
}
