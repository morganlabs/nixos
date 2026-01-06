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
      steam.enable = true;
      _1password.enable = true;
      mangohud.enable = true;
    };

    desktop.hyprland = {
      enable = true;
      monitors = [
        {
          # Built-in
          name = "eDP-1";
          scale = "1.57";
          position = "1920x528";
        }
        {
          # BenQ
          name = "DP-3";
          scale = "2";
          position = "2048x0";
          # 2048x0
        }
        {
          # MSI
          name = "DP-2";
          scale = "1.25";
          position = "0x0";
          # 0x0
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once =
    let
      autoTurnOffOnDisplay = pkgs.writeShellScript "turn-off-display-on-attach.sh" ''
        #!/usr/bin/env bash

        displays() {
            if [ "$1" = "monitoradded>>DP-3" ]; then
                hyprctl keyword monitor "eDP-1,disable"
            elif [ "$1" = "monitorremoved>>DP-3" ]; then
                hyprctl reload
            fi
        }

        ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do displays "$line" && sleep 0.1; done
      '';
    in
    mkAfter [
      "${autoTurnOffOnDisplay}/turn-off-display-on-attach.sh"
    ];

  services.teamviewer.enable = true;

  system.stateVersion = "26.05";
}
