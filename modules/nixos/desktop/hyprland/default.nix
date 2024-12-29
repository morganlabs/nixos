{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;

  variables = {
    "$mod" = "SUPER";
    "$alt" = "ALT";
  };
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Enable desktop.hyprland";
    features.autostart.enable = mkBoolOption "Autostart Hyprland on tty login" true;
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = mkForce true;
      xwayland.enable = mkDefault true;
    };

    home-manager.users.${vars.user.username} = {
      imports = [
        ./config/env.nix
        ./config/input.nix
        ./config/rules.nix
        ./config/decoration
        ./config/binds
      ];

      stylix.targets.hyprland.enable = mkDefault true;
      home.sessionVariables.NIXOS_OZONE_WL = mkForce "1";

      wayland.windowManager.hyprland = {
        enable = mkForce true;
        settings = variables;
      };

      programs.zsh.initExtra = mkIf cfg.features.autostart.enable ''
        if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
          dbus-run-session Hyprland
        fi
      '';
    };
  };
}
