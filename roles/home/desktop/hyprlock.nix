{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.desktop.hyprlock;
in
{
  options.roles.desktop.hyprlock = {
    enable = mkEnableOption "Enable Hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = with config.colorScheme.palette; {

        general = {
          hide_cursor = true;
          grace = 10;
          ignore_empty_input = true;
        };

        background = {
          monitor = "";
          color = "rgb(${base00})";

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

            inner_color = "rgb(${base00})";
            outer_color = "rgb(${base00})";
            font_color = "rgb(${base04})";

            fade_on_empty = false;

            placeholder_text = "";

            rounding = 0;

            check_color = "rgb(${base09})";
            fail_color = "rgb(${base08})";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            fail_transition = 256;

            capslock_color = "rgb(${base0E})";
            numlock_color = "rgb(${base0C})";
            bothlock_color = "rgb(${base0D})";

            position = "0, 128";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };
  };
}
