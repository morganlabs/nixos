{ config, lib, ... }:
let
  cfg = config.homeManagerModules.programs.hyprlock;

  mkLabel =
    text: font_size: position: halign: valign: extra:
    with config.stylix.base16Scheme;
    {
      inherit
        text
        font_size
        position
        halign
        valign
        ;
      monitor = "";
      font_family = "BlexMono Nerd Font";
      color = "rgb(${base04})";
    }
    // extra;
in
with lib;
{
  options.homeManagerModules.programs.hyprlock = {
    enable = mkEnableOption "Enable programs.hyprlock";
  };

  config = mkIf cfg.enable {
    stylix.targets.hyprlock.enable = true;
    programs.hyprlock = {
      enable = true;
      settings = with config.stylix.base16Scheme; {
        background = {
          blur_size = 8;
          blur_passes = 2;
          noise = 2.5e-2;
          brightness = 0.25;
        };

        general = {
          hide_cursor = true;
          grace = 10;
          ignore_empty_input = true;
        };

        label = [
          (mkLabel "$TIME" 64 "0, -160" "center" "top" { })
          (mkLabel ''cmd[update:1000] echo "$(date +'%A, %d %B')"'' 20 "0, -128" "center" "top" { })
        ];

        input-field = mkForce [
          {
            monitor = "";
            size = "512, 50";
            outline_thickness = 2;

            dots_size = 2.0e-2;
            dots_spacing = 0.2;
            dots_center = true;
            dots_rounding = 0;

            outer_color = "rgb(${base03})";
            inner_color = "rgb(${base00})";
            font_color = "rgb(${base05})";
            fail_color = "rgb(${base08})";
            check_color = "rgb(${base0A})";

            fade_on_empty = false;

            placeholder_text = "";

            rounding = 0;

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
