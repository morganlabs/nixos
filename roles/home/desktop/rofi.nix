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
  cfg = config.roles.desktop.rofi;
in
{
  options.roles.desktop.rofi = {
    enable = mkEnableOption "Enable Rofi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kora-icon-theme ];

    programs.rofi =
      with config.colorScheme.palette;
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        enable = true;
        package = pkgs.rofi-wayland;
        font = "BlexMono Nerd Font 16";

        extraConfig = {
          show-icons = true;
          icon-theme = "kora";
          drun-display-format = "{name}";
          fixed-num-lines = true;
          matching = "fuzzy";
        };

        theme = {
          "*" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "#${base04}";
          };

          "mainbox" = {
            spacing = mkLiteral "16px";
          };

          "window" = {
            width = 580;
          };

          "inputbar" = {
            padding-bottom = mkLiteral "16px";
          };

          "listview, inputbar" = {
            background-color = mkLiteral "#${base01}";
          };

          "entry" = {
            placeholder = "Type to search";
          };

          "element" = {
            padding = mkLiteral "16px";
            spacing = mkLiteral "16px";
          };

          "element selected" = {
            background-color = mkLiteral "#${base0E}";
          };

          "element-text selected" = {
            color = mkLiteral "#${base01}";
          };

          "element-icon" = {
            size = mkLiteral "1em";
          };

          "element-text" = {
            vertical-align = mkLiteral "0.5";
          };

          "inputbar" = {
            padding = mkLiteral "16px";
            children = map mkLiteral [ "entry" ];
            border = mkLiteral "3px";
            border-color = mkLiteral "#${base0E}";
          };

          "listview" = {
            fixed-height = true;
            lines = 6;
          };
        };
      };
  };
}
