{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.hyprlock;
in
{
  options.roles.hyprlock = {
    enable = mkEnableOption "Enable Hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = with config.colorScheme.palette; {

        general = {
          hide_cursor = true;
          grace = 0;
          ignore_empty_input = true;
        };

        background = {
          monitor = "";
          color = "rgb(${base01})";

          blur_passes = 3;
          blur_size = 3;
          noise = 2.5e-2;
          contrast = 0.9;
          brightness = 0.8;
          vibrancy = 0.0;
          vibrancy_darkness = 0.2;
        };

        label = [
          {
            monitor = "";
            text = "$TIME ";
            color = "rgb(${base04})";
            font_size = 64;
            font_family = "BlexMono Nerd Font";

            position = "0, -160";
            halign = "center";
            valign = "top";
          }

          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%A, %d %B')"'';
            color = "rgb(${base04})";
            font_size = 20;
            font_family = "BlexMono Nerd Font";

            position = "0, -128";
            halign = "center";
            valign = "top";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "512, 50";
            outline_thickness = 3;

            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            dots_rounding = 0;

            inner_color = "rgba(${base0E})";
            outer_color = "rgba(${base0E})";
            font_color = "rgb(${base04})";

            fade_on_empty = true;
            fade_timeout = 1000;

            placeholder_text = "";

            rounding = 5;

            check_color = "rgb(${base09})";
            fail_color = "rgb(${base08})";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            fail_transition = 256;

            position = "0, 128";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };
  };
}
