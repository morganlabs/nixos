{ config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
with config.stylix.base16Scheme;
{
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
}
