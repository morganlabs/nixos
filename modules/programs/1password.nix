{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}:
let
  cfg = config.modules.programs._1password;
in
with lib;
{
  options.modules.programs._1password = {
    enable = mkEnableOption "Enable programs._1password";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    modules.security.gnome-keyring.enable = mkForce true;
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings =
      mkIf cfg.features.hyprland.enable
        {
          exec-once = [ "[workspace special:s10 silent] ${pkgs._1password-gui}/bin/1password" ];
          windowrulev2 = [
            "workspace special:s10, class:(1Password), floating:0"
            "pin, class:(1Password), title:(1Password), floating:1"
          ];
        };

    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ vars.user.username ];
      };
    };
  };
}
