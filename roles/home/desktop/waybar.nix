{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.desktop.waybar;
in
{
  options.roles.desktop.waybar = {
    enable = mkEnableOption "Enable Waybar";

    modules = {
      volume.enable = mkOption {
        description = "Enable the volume indicator";
        type = types.bool;
        default = false;
      };

      brightness.enable = mkOption {
        description = "Enable the brightness indicator";
        type = types.bool;
        default = false;
      };

      network.enable = mkOption {
        description = "Enable the network indicator";
        type = types.bool;
        default = false;
      };

      bluetooth = {
        enable = mkOption {
          description = "Enable the bluetooth indicator";
          type = types.bool;
          default = false;
        };

        controller = mkOption {
          description = "Specify which Bluetooth controller to monitor";
          type = types.str;
          default = "";
        };
      };

      battery = {
        enable = mkOption {
          description = "Enable the battery indicator";
          type = types.bool;
          default = false;
        };

        bat = mkOption {
          description = "Specify which battery to monitor";
          type = types.str;
          default = "BAT0";
        };
      };

      tray.enable = mkOption {
        description = "Enable the system tray";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      builtins.concatLists [
        [ playerctl ]
        (if cfg.modules.bluetooth.enable then [ blueman ] else [ ])
        (if cfg.modules.volume.enable then [ pavucontrol ] else [ ])
        (if cfg.modules.brightness.enable then [ playerctl ] else [ ])
        (if cfg.modules.network.enable then [ ] else [ ])
      ];

    programs.waybar = {
      enable = true;

      style = with config.colorScheme.palette; ''
        * {
          font-family: "BlexMono Nerd Font";
          font-weight: 500;
          font-size: 1rem;
          color: #${base04};
          border: none;
          border-radius: 0;
          min-height: 0;
          transition: all 0s;
        }

        window#waybar {
          background: #${base01};
        }

        .modules-center * .module,
        .modules-right * .module {
          margin: 0 8px;
        }

        #workspaces .active {
          background-color: #${base0E};
        }

        #workspaces .active * {
          color: #${base00};
        }

        #window {
          padding: 0 16px;
        }

        #pulseaudio.muted {
          padding: 0 0px;
        }

        #battery.charged {
          color: #${base0B}
        }

        #battery.warning {
          color: #${base09}
        }

        #battery.critical {
          color: #${base08}
        }
      '';

      settings = [
        {
          layer = "top";
          position = "top";
          height = 32;
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [ "clock" ];
          modules-right = (
            builtins.concatLists [
              (if cfg.modules.brightness.enable then [ "backlight" ] else [ ])
              (if cfg.modules.volume.enable then [ "pulseaudio" ] else [ ])
              (if cfg.modules.battery.enable then [ "battery" ] else [ ])
              (if cfg.modules.bluetooth.enable then [ "bluetooth" ] else [ ])
              (if cfg.modules.network.enable then [ "network" ] else [ ])
              (if cfg.modules.tray.enable then [ "tray" ] else [ ])
            ]
          );

          bluetooth = {
            inherit (cfg.modules.bluetooth) controller;
            on-click = "blueman-manager";
            format = " {status}";
            format-on = " On";
            format-off = "󰂲 Off";
            format-disabled = "󰂲 Disabled";
            format-connected = "󰂱 Connected";
            tooltip-format-connected = "{device_alias}";
          };

          network = {
            format = "{icon} {essid}";
            format-wifi = "󰤨 {signalStrength}%";
            format-ethernet = "󰈀";
            format-disconnected = "󰤮 Disconnected";
            tooltip-format-wifi = "{essid} ({ipaddr})";
            tooltip-format-ethernet = "{ipaddr}";
          };

          tray = {
            show-passive-icons = true;
            spacing = 16;
          };

          backlight = {
            format = "{icon} {percent}%";
            tooltip = false;
            scroll-step = 5;
            reverse-scrolling = true;
            format-icons = [
              "󰃞"
              "󰃞"
              "󰃝"
              "󰃝"
              "󰃟"
              "󰃟"
              "󰃟"
              "󰃟"
              "󰃠"
              "󰃠"
            ];
          };

          battery = {
            inherit (cfg.modules.battery) bat;
            interval = 2;
            format = "{icon} {capacity}%";
            format-charging = "󱐋 {capacity}%";
            states = {
              charged = 100;
              default = 99;
              warning = 20;
              critical = 10;
            };
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };

          "hyprland/workspaces" = {
            format = "{icon}{id}";
            format-icons = {
              default = "";
              urgent = " ";
            };
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟";
            format-icons = {
              default = "󰕾";
              headphone = "󰋋";
              headset = "󰋋";
              speaker = "󰓃";
            };
            on-click = "pavucontrol";
            on-scroll-up = "pamixer -i 5";
            on-scroll-down = "pamixer -d 5";
            on-click-right = "pamixer --toggle-mute";
          };

          clock = with config.colorScheme.palette; {
            format = "<span color='#${base0E}'>{:%a</span>%e %b <span color='#${base0E}'>%H</span>:%M}";
            interval = 5;
            tooltip = false;
          };

          "hyprland/window" = {
            format = "{initialTitle}";
            separate-outputs = true;
            rewrite = {
              " - (.*)" = "$1";
              "- (.*)" = "$1";
              "Mozilla (.*)" = "$1";
              ".* - Discord" = "Discord";
              kitty = "Kitty";
            };
          };
        }
      ];
    };
  };
}
