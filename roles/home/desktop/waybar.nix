{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.waybar;
in
{
  options.roles.waybar = {
    enable = mkEnableOption "Enable Waybar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ playerctl ];
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
          background: #${base00};
        }

        .modules-center * .module,
        .modules-right * .module,
        #custom-music.module {
          margin: 0 8px;
        }

        #workspaces .active {
          background-color: #${base0E};
        }

        #workspaces .active * {
          color: #${base01};
        }

        #custom-power.flat {
          padding-right: 9px;
        }

        #custom-music.module {
          padding: 0 8px;
        }

        #pulseaudio.muted {
          padding: 0 0px;
        }
      '';

      settings = [
        {
          layer = "top";
          position = "top";
          height = 32;
          modules-left = [
            "hyprland/workspaces"
            "custom/music"
          ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "tray"
            "memory"
            "pulseaudio"
            "clock"
            "custom/power"
          ];

          memory = {
            interval = 1;
            format = "  {percentage}% ({used:0.1f}/{total:0.0f}GB)";
          };

          tray = {
            show-passive-icons = true;
            spacing = 16;
          };

          "hyprland/workspaces" = {
            format = "{icon}{id}";
            format-icons = {
              default = "";
              urgent = " ";
            };
          };

          "custom/music" = {
            exec = "playerctl metadata --follow --format \"{{ title }} - {{ artist }}\"";
            format = "󰎇 {}";
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

          clock = {
            format = "{:%A %d %B %H:%M}";
          };

          "custom/power" = {
            format = "⏻";
            on-click = "~/.config/waybar/scripts/power-menu.sh";
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
