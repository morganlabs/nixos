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
  cfg = config.modules.desktop.hyprland.settings.binds.workspaces.special.navigation;

  close-special-ws =
    let
      jq = "${pkgs.jq}/bin/jq";
    in
    pkgs.writeShellScriptBin "close-special-ws" ''
      #!/bin/bash
      active=$(hyprctl -j monitors | ${jq} --raw-output '.[] | select(.focused==true).specialWorkspace.name | split(":") | if length > 1 then .[1] else "" end')
      if [[ ''${#active} -gt 0 ]]; then
          hyprctl dispatch togglespecialworkspace "$active"
      fi
    '';
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.workspaces.special.navigation = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.workspaces.special.navigation";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind = mkAfter [
      # Switch between special workspaces
      "$alt, 1, togglespecialworkspace, s1"
      "$alt, 2, togglespecialworkspace, s2"
      "$alt, 3, togglespecialworkspace, s3"
      "$alt, 4, togglespecialworkspace, s4"
      "$alt, 5, togglespecialworkspace, s5"
      "$alt, 6, togglespecialworkspace, s6"
      "$alt, 7, togglespecialworkspace, s7"
      "$alt, 8, togglespecialworkspace, s8"
      "$alt, 9, togglespecialworkspace, s9"
      "$alt, 0, togglespecialworkspace, s10"

      # Close any special workspaces
      "$mod, grave, exec, ${close-special-ws}/bin/close-special-ws"
      "$alt, grave, exec, ${close-special-ws}/bin/close-special-ws"

      # Close special workspaces when navigating regular workspaces
      "$mod, 1, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 2, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 3, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 4, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 5, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 6, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 7, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 8, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 9, exec, ${close-special-ws}/bin/close-special-ws"
      "$mod, 0, exec, ${close-special-ws}/bin/close-special-ws"
    ];
  };
}
