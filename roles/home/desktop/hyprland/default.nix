{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.desktop.windowManager.hyprland;

  defaultAutostart = [
    "exec-once = [workspace 1 silent] kitty"
    "exec-once = [workspace 2 silent] firefox"
    "exec-once = [workspace 3 silent] obsidian"
    "exec-once = [workspace special:discord silent] discord"
    "exec-once = [workspace special:slack silent] slack"
    "exec-once = [workspace special:mail silent] betterbird"
    "exec-once=systemctl --user start plasma-polkit-agent"
  ];

  defaultExtraBinds = [
    "bind = $mainMod, code:49, togglespecialworkspace, discord"
    "bind = ALT, code:49, togglespecialworkspace, slack"
    "bind = Control_L, code:49, togglespecialworkspace, mail"
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
      includeDefault = mkOptionBool "Include default extra bindings" true;
      bindings = mkOptionListOf types.str "Additional bindings" [ ];
    };

    features = {
      startOnLogin.enable = mkOptionBool "Auto-start Hyprland from the TTY" true;
      screenshot.enable = mkOptionBool "Include the Screenshot script and binds" true;
      autostart = {
        includeDefault = mkOptionBool "Include default autostart programs" true;
        programs = mkOptionListOf types.str "Programs to autostart" [ ];
      };
    };

    functionRow = {
      brightness.enable = mkOptionBool "Include the config to use Function keys for brightness" true;
      volume.enable = mkOptionBool "Include the config to use Function keys for volume" true;
      music.enable = mkOptionBool "Include the config to use Function keys for music control" true;
    };

    programs = {
      hypridle.enable = mkOptionBool "Enable Hypridle" true;
      hyprlock.enable = mkOptionBool "Enable Hyprlock" true;
      rofi.enable = mkOptionBool "Enable Rofi" true;
      waybar.enable = mkOptionBool "Enable Waybar" true;
      mako.enable = mkOptionBool "Enable Mako" true;
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

        (mkIfList cfg.features.screenshot.enable [
          (writeShellScriptBin "screenshot" (builtins.readFile ./scripts/screenshot.sh))
          slurp
          grim
          jq
          wl-clipboard
        ])

        (mkIfList cfg.functionRow.brightness.enable [ brightnessctl ])
        (mkIfList cfg.functionRow.volume.enable [ pamixer ])
        (mkIfList cfg.functionRow.music.enable [ playerctl ])
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
            ${mkIfElse (cfg.features.autostart.includeDefault) (concatLines defaultAutostart) ""}
            ${(concatLines cfg.features.autostart.programs)}

            # Extra Binds
            ${mkIfElse (cfg.extraBinds.includeDefault) (concatLines defaultExtraBinds) ""}
            ${(concatLines cfg.extraBinds.bindings)}
          ''

          (mkIfStr cfg.programs.waybar.enable ''
            exec-once = ${pkgs.waybar}/bin/waybar
          '')

          (mkIfStr cfg.features.screenshot.enable ''
            bind = ALT SHIFT, 1, exec, screenshot selection
            bind = ALT SHIFT, 2, exec, screenshot window
            bind = ALT SHIFT, 3, exec, screenshot all
          '')

          (mkIfStr cfg.functionRow.brightness.enable ''
            bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
            bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
          '')

          (mkIfStr cfg.functionRow.volume.enable ''
            bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
            bind = , XF86AudioLowerVolume, exec, pamixer -d 5
            bind = , XF86AudioMute, exec, pamixer --toggle-mute
          '')

          (mkIfStr cfg.functionRow.music.enable ''
            bind = , XF86AudioPrev, exec, playerctl previous
            bind = , XF86AudioNext, exec, playerctl next
            bind = , XF86AudioPlay, exec, playerctl play-pause
            bind = , XF86AudioPause, exec, playerctl play-pause
          '')
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
