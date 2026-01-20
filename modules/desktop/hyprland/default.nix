{
  config,
  lib,
  vars,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland;

  hyprlandInput = inputs.hyprland.packages.${vars.system};

  monitors = map (
    display:
    with display;
    "${name},${resolution}${mkIfElse (refreshRate == "") "" "@${refreshRate}"},${position},${scale}"
  ) cfg.monitors;
in
{
  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Enable desktop.hyprland";
    withUWSM = mkEnableOption "Enable UWSM";

    monitors = mkOption {
      description = "A list of display configurations";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = mkStringOption "The name of the monitor to affect" "";
            resolution = mkStringOption "The resolution to use" "preferred";
            refreshRate = mkStringOption "The refresh rate to use" "";
            position = mkStringOption "The position of the monitor" "auto";
            scale = mkStringOption "The scale to use" "auto";
          };
        }
      );
    };
  };

  imports = [
    ./smart-gaps.nix
    ./binds.nix
  ];

  config = mkIf cfg.enable {
    age.secrets.weather-api-key = {
      file = mkForce ../../../secrets/${vars.hostname}/weather-api-key.age;
      # Grant user ownership so Hyprpanel can read the API key
      owner = vars.user.username;
      group = "users";
      mode = "0400";
    };

    modules = {
      programs = {
        firefox.enable = mkDefault true;
      };

      desktop.hyprland = {
        withUWSM = mkDefault true;
        smart-gaps.enable = mkDefault true;
      };
    };

    programs.uwsm.enable = cfg.withUWSM;

    programs.hyprland = {
      enable = mkForce true;
      package = hyprlandInput.hyprland;
      portalPackage = hyprlandInput.xdg-desktop-portal-hyprland;
      xwayland.enable = mkForce true;
      withUWSM = mkForce cfg.withUWSM;
    };

    environment.systemPackages = with pkgs; [
      kitty
      hyprlauncher
      adwaita-icon-theme
    ];

    home-manager.users.${vars.user.username} = {
      stylix.targets = {
        hyprland.enable = true;
        hyprpaper.image.enable = true;
        hyprpanel.enable = true;
      };

      services.hyprpaper.enable = mkForce true;

      wayland.windowManager.hyprland = {
        enable = mkForce true;
        package = hyprlandInput.hyprland;
        portalPackage = hyprlandInput.xdg-desktop-portal-hyprland;

        settings = {
          monitor = monitors ++ [
            ",preferred,auto,auto"
          ];

          device = [
            {
              name = "pixa3854:00-093a:0274-touchpad";
              sensitivity = 0.25;
            }
            {
              name = "logitech-mx-master-2s-1";
              sensitivity = -0.5;
            }
          ];

          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            rounding_power = 2;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 1;

              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = true;

            bezier = [
              "easeOutQuint, 0.23, 1,0.32, 1"
              "easeInOutCubic, 0.65, 0.05, 0.36, 1"
              "linear, 0,0,1,1"
              "almostLinear, 0.5,0.5,0.75, 1"
              "quick,0.15, 0,0.1,1"
            ];

            animation = [
              "global,1, 10,default"
              "border,1, 5.39,easeOutQuint"
              "windows, 1, 4.79,easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut,1, 1.49,linear, popin 87%"
              "fadeIn,1, 1.73,almostLinear"
              "fadeOut, 1, 1.46,almostLinear"
              "fade,1, 3.03,quick"
              "layers,1, 3.81,easeOutQuint"
              "layersIn,1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn,1, 1.79,almostLinear"
              "fadeLayersOut, 1, 1.39,almostLinear"
              "workspaces,1, 1.94,almostLinear, fade"
              "workspacesIn,1, 1.21,almostLinear, fade"
              "workspacesOut, 1, 1.94,almostLinear, fade"
              "zoomFactor,1, 7, quick"
            ];
          };

          windowrule = [
            {
              # Ignore maximize requests from all apps. You'll probably like this.
              name = "suppress-maximize-events";
              "match:class" = ".*";

              suppress_event = "maximize";
            }

            {
              # Fix some dragging issues with XWayland
              name = "fix-xwayland-drags";
              "match:class" = "^$";
              "match:title" = "^$";
              "match:xwayland" = true;
              "match:float" = true;
              "match:fullscreen" = false;
              "match:pin" = false;

              no_focus = true;
            }

            # Hyprland-run windowrule
            {
              name = "move-hyprland-run";

              "match:class" = "hyprland-run";

              move = "20 monitor_h-120";
              float = true;
            }
          ];

          dwindle = {
            "pseudotile" = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            "preserve_split" = true; # You probably want this
          };

          master = {
            new_status = "master";
          };

          misc = {
            "force_default_wallpaper" = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
            "disable_hyprland_logo" = mkForce false; # If true disables the random hyprland logo / anime girl background. :(
          };

          input = {
            kb_layout = "gb";
            kb_options = "caps:escape";

            follow_mouse = 1;

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

            touchpad = {
              natural_scroll = true;
            };
          };

          gesture = [ "3, horizontal, workspace" ];
        };
      };

      programs.hyprpanel = {
        enable = true;
        settings = {
          theme = {
            font.size = "16px";
            bar = {
              transparent = true;
              location = "top";
              outer_spacing = "8px";
            };
          };

          scalingPriority = "hyprland";

          # 1. Bar Layout (Applied to all monitors)
          bar.layouts = {
            "*" = {
              left = [
                "dashboard"
                "workspaces"
              ];
              middle = [ "clock" ];
              right = [
                "systray"
                "media"
                "battery"
                "volume"
                "microphone"
                "bluetooth"
                "network"
                "notifications"
              ];
            };
          };

          menus.dashboard = {
            shortcuts.enabled = false;
            directories.enabled = false;
            controls.enabled = false;
            stats.enable_storage = true;
            powermenu.avatar = {
              name = head (split " " vars.user.fullName);
              image = vars.user.face;
            };
          };

          # Use 24h for clock w/ no seconds, metric weather units
          menus.clock = {
            time = {
              military = true;
              hideSeconds = true;
            };
            weather = {
              unit = "metric";
              key = config.age.secrets.weather-api-key.path;
              location = "Denbighshire";
            };
          };

          # Auto-detect distro icon
          bar.launcher.autoDetectIcon = true;

          # 3. Workspaces: Use numbers
          bar.workspaces = {
            show_icons = false;
            showWsIcons = true;
            showApplicationIcons = true;
          };

          # 4. Clock (Date): Hide icon and remove padding
          bar.clock.showIcon = false;
          theme.bar.buttons.clock.spacing = "0px"; # Removes internal icon/text padding
          bar.clock.format = "%a, %b %-e %-k:%M";

          # 5. Media: Hide when no media is playing
          bar.media.show_active_only = true;

          # 6. Bluetooth & WiFi: Hide labels
          bar.bluetooth.label = false;
          bar.network.label = false;

          # 7. Notifications: Show count when not empty
          bar.notifications.show_total = true;
          bar.notifications.hide_empty_count = true; # Only shows if count > 0
        };
      };
    };

    nix.settings = {
      substituters = mkAfter [ "https://hyprland.cachix.org" ];
      trusted-substituters = mkAfter [ "https://hyprland.cachix.org" ];
      trusted-public-keys = mkAfter [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
