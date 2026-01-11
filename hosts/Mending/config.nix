{
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:
with lib;
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  modules = {
    core.enable = true;
    bootloader.lanzaboote.enable = true;

    services = {
      power-management.enable = true;
      fprintd.enable = true;
    };

    programs = {
      prism-launcher.enable = true;
      _1password.enable = true;
    };

    desktop.hyprland = {
      enable = true;
      monitors = [
        {
          # Built-in
          name = "eDP-1";
          scale = "1.57";
          position = "9999x9999";
        }
        {
          # BenQ
          name = "DP-3";
          scale = "2";
          position = "2048x0";
        }
        {
          # MSI
          name = "DP-2";
          scale = "1.25";
          position = "0x0";
        }
      ];
    };

    programs.stylix.wallpaper = ./wallpaper.png;
  };

  programs.ssh.extraConfig = mkAfter ''
    host unbreaking
      HostName unbreaking.morganlabs.dev
      Port 32107
      ForwardAgent yes
  '';

  home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once =
    let
      mainExternalMonitor.description = "BNQ BenQ RD280U PBR0062401Q";
      internalMonitor.port = "eDP-1";

      socat = "${pkgs.socat}/bin/socat";
      jq = "${pkgs.jq}/bin/jq";

      autoTurnOffOnDisplay = pkgs.writeShellScript "turn-off-display-on-attach.sh" ''
        #!/usr/bin/env bash

        check_if_connected() {
          hyprctl monitors -j | ${jq} 'any(.[]; .description == "${mainExternalMonitor.description}")'
        }

        IS_ALREADY_CONNECTED="$(check_if_connected)"

        if [[ "$IS_ALREADY_CONNECTED" == true ]]; then
          hyprctl keyword monitor "${internalMonitor.port},disable"
        fi

        handle_event() {
          local line="$1"
          local event="''${line%%>>*}"
          local data="''${line#*>>}"
          local desc="$(printf '%s\n' "$data" | awk -F',' '{print $3}')"

          case "$event" in
            configreloaded)
              IS_ALREADY_CONNECTED="$(check_if_connected)"
              if [[ "$IS_ALREADY_CONNECTED" == true ]]; then
                hyprctl keyword monitor "${internalMonitor.port},disable"
              fi
              ;;
            monitoraddedv2)
              if [ "$desc" = "${mainExternalMonitor.description}" ]; then
                hyprctl keyword monitor "${internalMonitor.port},disable"
              fi
              ;;
            monitorremovedv2)
              if [ "$desc" = "${mainExternalMonitor.description}" ]; then
                hyprctl reload
              fi
              ;;
          esac
        }

        ${socat} -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle_event "$line"; done
      '';
    in
    mkAfter [ "${autoTurnOffOnDisplay}" ];

  services.teamviewer.enable = true;

  system.stateVersion = "26.05";
}
