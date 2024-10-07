{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.desktop.mako;
in
{
  options.roles.desktop.mako = {
    enable = mkEnableOption "Enable Mako";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ libnotify ];

    services.mako = with config.colorScheme.palette; {
      enable = true;

      font = "BlexMono Nerd Font 14";
      format = ''<span font="10">%a</span>\n<b>%s</b>\n<span font="12">%b</span>'';
      layer = "overlay";
      backgroundColor = "#${base01}";
      borderColor = "#${base0E}";
      textColor = "#${base04}";
      width = 380;
      height = 125;
      margin = "10";
      padding = "10";
      borderSize = 2;
      maxIconSize = 48;
      defaultTimeout = 5000;
      ignoreTimeout = true;
    };
  };
}
