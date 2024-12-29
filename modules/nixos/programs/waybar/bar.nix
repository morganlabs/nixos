cfg:
{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  modules = cfg.modules;
in
{
  home.packages =
    with pkgs;
    builtins.concatLists [
      (mkIfList modules.bluetooth.enable [ blueman ])
      (mkIfList modules.pulseaudio.enable [
        pavucontrol
        pamixer
      ])
    ];

  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 32;
      modules-left = with modules; [
        (mkIfStr workspaces.enable "hyprland/workspaces")
        (mkIfStr window.enable "hyprland/window")
      ];
      modules-center = with modules; [ (mkIfStr clock.enable "clock") ];
      modules-right = with modules; [
        (mkIfStr backlight.enable "backlight")
        (mkIfStr pulseaudio.enable "pulseaudio")
        (mkIfStr battery.enable "battery")
        (mkIfStr bluetooth.enable "bluetooth")
        (mkIfStr network.enable "network")
        (mkIfStr tray.enable "tray")
      ];
      tray = mkIf cfg.modules.tray.enable {
        show-passive-icons = true;
        spacing = 16;
      };
      pulseaudio =
        with pkgs;
        mkIf cfg.modules.pulseaudio.enable {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          on-click = "${pavucontrol}/bin/pavucontrol";
          on-scroll-up = "${pamixer}/bin/pamixer -i 5";
          on-scroll-down = "${pamixer}/bin/pamixer -d 5";
          on-click-right = "${pamixer}/bin/pamixer --toggle-mute";
          format-icons = {
            default = "󰕾";
            headphone = "󰋋";
            headset = "󰋋";
            speaker = "󰓃";
          };
        };
      network = mkIf cfg.modules.network.enable {
        format = "{icon} {essid}";
        format-wifi = "󰤨 {signalStrength}%";
        format-ethernet = "󰈀 Connected";
        format-disconnected = "󰤮 Disconnected";
        tooltip-format-wifi = "{essid} ({ipaddr})";
        tooltip-format-ethernet = "{ipaddr}";
      };
      clock =
        with config.stylix.base16Scheme;
        mkIf cfg.modules.clock.enable {
          format = "<span color='#${base0E}'>{:%a</span> %e %b <span color='#${base0E}'>%H</span>:%M}";
          interval = 5;
          tooltip = false;
        };
      bluetooth = mkIf cfg.modules.bluetooth.enable {
        inherit (cfg.modules.bluetooth) controller;
        on-click = "blueman-manager";
        format = " {status}";
        format-on = " On";
        format-off = "󰂲 Off";
        format-disabled = "󰂲 Disabled";
        format-connected = "󰂱 Connected";
        tooltip-format-connected = "{device_alias}";
      };
      battery = mkIf cfg.modules.battery.enable {
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
      backlight = mkIf cfg.modules.backlight.enable {
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
      "hyprland/workspaces" = mkIf cfg.modules.workspaces.enable {
        format = "{icon}{id}";
        format-icons = {
          default = "";
          urgent = " ";
        };
      };
      "hyprland/window" = mkIf cfg.modules.window.enable {
        format = "{initialTitle}";
        separate-outputs = true;
        rewrite = {
          kitty = "Kitty";
          ".* - Discord" = "Discord";
          ".* - Obsidian v.*" = "Obsidian";
          " - (.*)" = "$1";
          "- (.*)" = "$1";
          "Mozilla (.*)" = "$1";
          "(.*) Premium" = "$1";
        };
      };
    }
  ];
}
