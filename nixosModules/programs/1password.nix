{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}:
let
  cfg = config.nixosModules.programs._1password;
in
with lib;
{
  options.nixosModules.programs._1password = {
    enable = mkEnableOption "Enable programs._1password";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    nixosModules.security.gnome-keyring.enable = mkForce true;
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings =
      mkIf cfg.features.hyprland.enable
        {
          exec-once = [ "[workspace special:10 silent] ${pkgs._1password-gui}/bin/1password" ];
          windowrulev2 = [ "workspace special:10, class:(1Password)" ];
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
