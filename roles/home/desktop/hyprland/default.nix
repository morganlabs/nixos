{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.desktop.windowManager.hyprland;

  defaultAutostart = [
    "exec-once = [workspace 1 silent] kitty"
    "exec-once = [workspace 2 silent] firefox"
    "exec-once = [workspace 3 silent] obsidian"
    "exec-once = [workspace special:discord silent] discord"
    "exec-once = [workspace special:mail silent] betterbird"
    "exec-once=systemctl --user start plasma-polkit-agent"
  ];

  defaultExtraBinds = [
    "bind = $mainMod, code:49, togglespecialworkspace, discord"
    "bind = $mainMod SHIFT, code:49, togglespecialworkspace, mail"
  ];
in
{
  imports = [
    ../hypridle.nix
    ../hyprlock.nix
    ../rofi.nix
    ../waybar.nix
    ../mako.nix
  ];

  options.roles.desktop.windowManager.hyprland = {
    enable = mkEnableOption "Enable Hyprland";

    extraBinds = {
      includeDefault = mkOption {
        type = types.bool;
        description = "Include default extra bindings";
        default = true;
      };

      bindings = mkOption {
        type = types.listOf types.str;
        description = "Additional bindings";
        default = [ ];
      };
    };

    features = {
      startOnLogin.enable = mkOption {
        type = types.bool;
        description = "Auto-start Hyprland from the TTY";
        default = true;
      };

      autostart = {
        includeDefault = mkOption {
          type = types.bool;
          description = "Include default autostart programs";
          default = true;
        };

        programs = mkOption {
          type = types.listOf types.str;
          description = "Programs to autostart";
          default = [ ];
        };
      };

      screenshot.enable = mkOption {
        type = types.bool;
        description = "Include the Screenshot script and binds";
        default = true;
      };
    };

    functionRow = {
      brightness.enable = mkOption {
        type = types.bool;
        description = "Include the config to use Function keys for brightness";
        default = true;
      };

      volume.enable = mkOption {
        type = types.bool;
        description = "Include the config to use Function keys for volume";
        default = true;
      };

      music.enable = mkOption {
        type = types.bool;
        description = "Include the config to use Function keys for music control";
        default = true;
      };
    };

    programs = {
      hypridle.enable = mkOption {
        type = types.bool;
        description = "Enable Hypridle";
        default = true;
      };

      hyprlock.enable = mkOption {
        type = types.bool;
        description = "Enable Hyprlock";
        default = true;
      };

      rofi.enable = mkOption {
        type = types.bool;
        description = "Enable Rofi";
        default = true;
      };

      waybar.enable = mkOption {
        type = types.bool;
        description = "Enable Waybar";
        default = true;
      };

      mako.enable = mkOption {
        type = types.bool;
        description = "Enable Mako";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      builtins.concatLists [
        [
          dconf
          wl-clipboard
          wev
          kdePackages.polkit-kde-agent-1
        ]

        (
          if cfg.features.screenshot.enable then
            [
              (writeShellScriptBin "screenshot" (builtins.readFile ./scripts/screenshot.sh))
              slurp
              grim
              jq
              wl-clipboard
            ]
          else
            [ ]
        )

        (if cfg.functionRow.brightness.enable then [ brightnessctl ] else [ ])
        (if cfg.functionRow.volume.enable then [ pamixer ] else [ ])
        (if cfg.functionRow.music.enable then [ playerctl ] else [ ])
      ];

    roles.desktop = {
      hypridle.enable = cfg.programs.hypridle.enable;
      hyprlock.enable = cfg.programs.hyprlock.enable;
      rofi.enable = cfg.programs.rofi.enable;
      waybar.enable = cfg.programs.waybar.enable;
      mako.enable = cfg.programs.mako.enable;
    };

    services.network-manager-applet.enable = true;

    programs.zsh.initExtra = mkIf cfg.features.startOnLogin.enable ''
      if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
      dbus-run-session Hyprland
      fi
    '';

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;

      xwayland.enable = true;
      extraConfig =
        with config.colorScheme.palette;
        strings.concatStrings [
          (builtins.readFile ./binds.conf)
          (builtins.readFile ./inputs.conf)
          (builtins.readFile ./window_rules.conf)
          (builtins.readFile ./decoration.conf)
          ''
            misc:background_color = rgb(${base00})

            general {
              col.active_border = rgb(${base0E})
              col.inactive_border = rgb(${base01})

              resize_on_border = true
              extend_border_grab_area = true
            }

            # Autostart
            ${if (cfg.features.autostart.includeDefault) then (concatLines defaultAutostart) else ""}
            ${(concatLines cfg.features.autostart.programs)}

            # Extra Binds
            ${if (cfg.extraBinds.includeDefault) then (concatLines defaultExtraBinds) else ""}
            ${(concatLines cfg.extraBinds.bindings)}
          ''

          (
            if cfg.programs.waybar.enable then
              ''
                exec-once = ${pkgs.waybar}/bin/waybar
              ''
            else
              ""
          )

          (
            if cfg.features.screenshot.enable then
              ''
                bind = ALT SHIFT, 1, exec, screenshot selection
                bind = ALT SHIFT, 2, exec, screenshot window
                bind = ALT SHIFT, 3, exec, screenshot all
              ''
            else
              ""
          )

          (
            if cfg.functionRow.brightness.enable then
              ''
                bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
                bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
              ''
            else
              ""
          )

          (
            if cfg.functionRow.volume.enable then
              ''
                bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
                bind = , XF86AudioLowerVolume, exec, pamixer -d 5
                bind = , XF86AudioMute, exec, pamixer --toggle-mute
              ''
            else
              ""
          )

          (
            if cfg.functionRow.music.enable then
              ''
                bind = , XF86AudioPrev, exec, playerctl previous
                bind = , XF86AudioNext, exec, playerctl next
                bind = , XF86AudioPlay, exec, playerctl play-pause
                bind = , XF86AudioPause, exec, playerctl play-pause
              ''
            else
              ""
          )
        ];
    };

    home = {
      sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use Wayland

      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = {
        name = "Sans";
        size = 11;
      };
    };
  };
}
