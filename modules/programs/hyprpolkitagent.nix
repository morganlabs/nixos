{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.hyprpolkitagent;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.hyprpolkitagent = {
    enable = mkEnableOption "Enable programs.hyprpolkitagent";
    features.hyprland.enable = mkBoolOption "Enable Hyprpolkit Agent in Hyprland (why wouldn't you?)" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprpolkitagent ];
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once = [
      "systemctl --user start hyprpolkitagent"
    ];
  };
}
