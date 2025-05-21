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
  cfg = config.modules.desktop.hyprland;
  hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};

  variables = {
    "$mod" = "SUPER";
    "$alt" = "ALT";
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./settings
    ./binds
    ./decoration
    ./hypr
    ./autostart
    ./defaultPrograms.nix
    ./cachix.nix
  ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Enable desktop.hyprland";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    modules = {
      hardware.audio.pipewire.enable = mkForce true;

      misc = {
        xdgUserDirs.usingWindowManager = mkForce true;
        cursor.enable = mkForce true;
      };

      desktop.hyprland = {
        cachix.enable = mkForce true;
        defaultPrograms.enable = mkDefault true;

        hypr = {
          paper.enable = mkDefault true;
          lock.enable = mkDefault true;
          polkitagent.enable = mkDefault true;
        };

        settings = {
          keyboard-layout.enable = mkDefault true;
          focus-follows-cursor.enable = mkDefault true;
          natural-scroll.touchpad.enable = mkDefault true;
          windows.resize-on-border.enable = mkDefault true;

          binds = {
            basic.enable = mkForce true;

            windows = {
              movement.enable = mkDefault true;
              toggle-floating.enable = mkDefault true;
            };

            workspaces = {
              regular.navigation.enable = mkDefault true;
              special.navigation.enable = mkDefault true;
            };

            functions = {
              brightness.enable = mkDefault true;
              volume.enable = mkDefault true;
              media.enable = mkDefault true;
            };
          };

          decoration = {
            blur.enable = mkDefault true;

            windows = {
              gaps.enable = mkDefault true;
              borders.enable = mkDefault true;
              rounding.enable = mkDefault true;
            };
          };
        };
      };
    };

    programs.hyprland = {
      enable = mkForce true;
      package = mkForce hyprPkgs.hyprland;
      portalPackage = mkForce hyprPkgs.xdg-desktop-portal-hyprland;
    };

    home-manager.users.${vars.user.username} = {
      stylix.targets.hyprland.enable = mkForce true;

      wayland.windowManager.hyprland = {
        enable = mkForce true;
        xwayland.enable = mkForce true;
        settings = variables // {
          animations.enabled = mkDefault false;
          windowrulev2 = mkBefore [
            "suppressevent maximise, class:*"

            # Make the File Chooser floating and centred
            "float, initialTitle:(Open Files)"
            "center, initialTitle:(Open Files)"
          ];

          misc = {
            disable_hyprland_logo = mkForce true;
            force_default_wallpaper = mkForce false;
            middle_click_paste = mkForce false;
          };

          env =
            let
              cursor = config.modules.misc.cursor;
            in
            mkBefore [
              "ELECTRON_OZONE_PLATFORM_HINT,wayland"
              "NIXOS_OZONE_WL,1"

              "XDG_CURRENT_DESKTOP,Hyprland"
              "XDG_SESSION_TYPE,wayland"
              "XDG_SESSION_DESKTOP,Hyprland"

              "HYPRCURSOR_THEME,${cursor.name}"
              "XCURSOR_THEME,${cursor.name}"
              "HYPRCURSOR_SIZE,${toString cursor.size}"
              "XCURSOR_SIZE,${toString cursor.size}"
            ];
        };
      };
    };
  };
}
