{ pkgs, lib, ... }:
let
  close-special = pkgs.writeShellScriptBin "close-special" ''
    #!/bin/bash
    active=$(hyprctl -j monitors | jq --raw-output '.[] | select(.focused==true).specialWorkspace.name | split(":") | if length > 1 then .[1] else "" end')
    if [[ ''${#active} -gt 0 ]]; then
        hyprctl dispatch togglespecialworkspace "$active"
    fi
  '';
in
with lib;
{
  home.packages = with pkgs; [
    jq
    close-special
  ];

  wayland.windowManager.hyprland.settings.bind = [
    # Close any special workspaces
    "$mod, grave, exec, ${close-special}/bin/close-special"
    "$alt, grave, exec, ${close-special}/bin/close-special"

    ## Switch workspaces
    "$mod, 1, workspace, 1"
    "$mod, 1, exec, ${close-special}/bin/close-special"

    "$mod, 2, workspace, 2"
    "$mod, 2, exec, ${close-special}/bin/close-special"

    "$mod, 3, workspace, 3"
    "$mod, 3, exec, ${close-special}/bin/close-special"

    "$mod, 4, workspace, 4"
    "$mod, 4, exec, ${close-special}/bin/close-special"

    "$mod, 5, workspace, 5"
    "$mod, 5, exec, ${close-special}/bin/close-special"

    "$mod, 6, workspace, 6"
    "$mod, 6, exec, ${close-special}/bin/close-special"

    "$mod, 7, workspace, 7"
    "$mod, 7, exec, ${close-special}/bin/close-special"

    "$mod, 8, workspace, 8"
    "$mod, 8, exec, ${close-special}/bin/close-special"

    "$mod, 9, workspace, 9"
    "$mod, 9, exec, ${close-special}/bin/close-special"

    "$mod, 0, workspace, 10"
    "$mod, 0, exec, ${close-special}/bin/close-special"

    # Switch between special workspaces
    # ONLY do this if there is not a pre-existing Alt+{0-9} binding
    "$alt, 1, togglespecialworkspace, s1"
    "$alt, 2, togglespecialworkspace, s2"
    "$alt, 3, togglespecialworkspace, s3"
    "$alt, 4, togglespecialworkspace, s4"
    "$alt, 5, togglespecialworkspace, s5"
    "$alt, 6, togglespecialworkspace, s6"
    "$alt, 7, togglespecialworkspace, s7"
    "$alt, 8, togglespecialworkspace, s9"
    "$alt, 0, togglespecialworkspace, s10"
  ];
}
