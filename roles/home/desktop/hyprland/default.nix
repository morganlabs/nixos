{
  config,
  lib,
  myLib,
  pkgs,
  inputs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.desktop.hyprland;
in
{
  options.roles.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
    extra.binds = mkOptionListOf types.str "Additional bindings" [ ];

    features = {
      autostart = mkOptionListOf types.str "Programs to autostart" [ ];
      startOnLogin.enable = mkOptionBool "Auto-start Hyprland from the TTY" false;
      screenshot.enable = mkOptionBool "Include the Screenshot script and binds" false;

      brightness.enable = mkOptionBool "Include the config to use Function keys for brightness" false;
      volume.enable = mkOptionBool "Include the config to use Function keys for volume" true;
      music.enable = mkOptionBool "Include the config to use Function keys for music control" false;
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      builtins.concatLists [
        [
          (writeShellScriptBin "reset-portals" (import ./scripts/resetPortals.nix { inherit pkgs; }))
          dconf
          wl-clipboard
          wev
          kdePackages.polkit-kde-agent-1
        ]
        (mkIfList cfg.features.brightness.enable [ brightnessctl ])
        (mkIfList cfg.features.volume.enable [ pamixer ])
        (mkIfList cfg.features.music.enable [ playerctl ])
        (mkIfList cfg.features.screenshot.enable [
          (writeShellScriptBin "screenshot" (builtins.readFile ./scripts/screenshot.sh))
          slurp
          grim
          jq
        ])
      ];

    programs.zsh.initExtra =
      mkIf (cfg.features.startOnLogin.enable && config.roles.programs.zsh.enable)
        ''
          if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
            dbus-run-session Hyprland
          fi
        '';

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "hyprland";
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
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

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      extraConfig =
        with config.colorScheme.palette;
        strings.concatStrings [
          (builtins.readFile ./binds.conf)
          (builtins.readFile ./inputs.conf)
          (builtins.readFile ./window_rules.conf)
          (builtins.readFile ./decoration.conf)
          (builtins.readFile ./env.conf)
          (import ./config.nix {
            inherit
              config
              cfg
              lib
              myLib
              pkgs
              ;
          })
        ];
    };
  };
}
