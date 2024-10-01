{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.hyprland;
in
{
  imports = [
    ../hypridle.nix
    ../hyprlock.nix
    ../rofi.nix
    ../waybar.nix
    ../mako.nix

    ../../programs/kitty.nix
    ../../programs/firefox
  ];

  options.roles.hyprland = {
    enable = mkEnableOption "Enable Hyprland";

    features = {
      autostart = mkOption {
        type = types.bool;
        description = "Auto-start Hyprland from the TTY";
        default = true;
      };

      screenshot = mkOption {
        type = types.bool;
        description = "Include the Screenshot script and binds";
        default = true;
      };
    };

    functionRow = {
      brightness = mkOption {
        type = types.bool;
        description = "Include the config to use Function keys for brightness";
        default = true;
      };

      volume = mkOption {
        type = types.bool;
        description = "Include the config to use Function keys for volume";
        default = true;
      };

      music = mkOption {
        type = types.bool;
        description = "Include the config to use Function keys for music control";
        default = true;
      };
    };

    programs = {
      hypridle = mkOption {
        type = types.bool;
        description = "Enable Hypridle";
        default = true;
      };

      hyprlock = mkOption {
        type = types.bool;
        description = "Enable Hyprlock";
        default = true;
      };

      rofi = mkOption {
        type = types.bool;
        description = "Enable Rofi";
        default = true;
      };

      waybar = mkOption {
        type = types.bool;
        description = "Enable Waybar";
        default = true;
      };

      mako = mkOption {
        type = types.bool;
        description = "Enable Mako";
        default = true;
      };

      kitty = mkOption {
        type = types.bool;
        description = "Enable Kitty";
        default = true;
      };

      firefox = mkOption {
        type = types.bool;
        description = "Enable Firefox";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; (mkMerge [
      [
        swaybg
        dconf
        wl-clipboard
        wev
        kdePackages.polkit-kde-agent-1
      ]

      (mkIf cfg.features.screenshot [
        (writeShellScriptBin "screenshot" (builtins.readFile ./scripts/screenshot.sh))
        slurp
        grim
        jq
	wl-clipboard
      ])

      (mkIf cfg.functionRow.brightness [ brightnessctl ])
      (mkIf cfg.functionRow.volume [ pamixer ])
      (mkIf cfg.functionRow.music [ playerctl ])
    ]);

    roles = {
      hypridle.enable = cfg.programs.hypridle;
      hyprlock.enable = cfg.programs.hyprlock;
      rofi.enable = cfg.programs.rofi;
      waybar.enable = cfg.programs.waybar;
      mako.enable = cfg.programs.mako;
      kitty.enable = cfg.programs.kitty;
      firefox.enable = cfg.programs.firefox;
    };

    services.network-manager-applet.enable = true;

    programs.zsh.initExtra = mkIf cfg.features.autostart ''
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
      extraConfig = with config.colorScheme.palette; strings.concatStrings [
        (builtins.readFile ./binds.conf)
        (builtins.readFile ./inputs.conf)
        (builtins.readFile ./autostart.conf)
        (builtins.readFile ./window_rules.conf)
        (builtins.readFile ./decoration.conf)
	''
	exec-once = waybar
	exec-once = swaybg -c "#${base00}"

	general {
	  col.active_border = rgb(${base0E})
	  col.inactive_border = rgb(${base01})
	}
        ''
	(if cfg.features.screenshot then ''
          bind = ALT SHIFT, 1, exec, screenshot selection
          bind = ALT SHIFT, 2, exec, screenshot window
          bind = ALT SHIFT, 3, exec, screenshot all
	'' else "")

	(if cfg.functionRow.brightness then ''
          bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
          bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-
	'' else "")

	(if cfg.functionRow.volume then ''
          bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
          bind = , XF86AudioLowerVolume, exec, pamixer -d 5
          bind = , XF86AudioMute, exec, pamixer --toggle-mute
	'' else "")

	(if cfg.functionRow.music then ''
          bind = , XF86AudioPrev, exec, playerctl previous
          bind = , XF86AudioNext, exec, playerctl next
          bind = , XF86AudioPlay, exec, playerctl play-pause
          bind = , XF86AudioPause, exec, playerctl play-pause
	'' else "")
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
