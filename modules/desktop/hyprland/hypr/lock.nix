{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.hypr.lock;
  font_family = config.stylix.fonts.sansSerif.name;

  shadow_passes = 4;
  shadow_size = 5;
  shadow_color = "rgba(0, 0, 0, 0.5)";

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
        shadow_size
        shadow_color
        shadow_passes
        ;
      monitor = "";
      color = "rgb(${base05})";
    }
    // extra;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.hypr.lock = {
    enable = mkEnableOption "Enable desktop.hyprland.hypr.lock";
    hypridle = {
      enable = mkBoolOption "Use Hypridle to auto-start Hyprlock" true;
      lockTimeout = mkIntOption "How many minutes until auto-lock" 5;
      sleepTimeout = mkIntOption "How many minutes until auto-sleep" 10;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.hyprlock.enable = mkForce true;
      wayland.windowManager.hyprland.settings = {
        bind = [ "$alt SHIFT, q, exec, hyprlock --immediate --immediate-render" ];
        bindl = [ ", switch:off:Lid Switch, exec, hyprlock --immediate --immediate-render" ];
      };

      programs.hyprlock = {
        enable = true;
        settings = {
          animations.enabled = false;

          general = {
            hide_cursor = mkForce false;
            grace = mkForce 10;
            ignore_empty_input = mkForce false;
          };

          label = [
            (mkLabel ''cmd[update:1000] echo "$(date +'%A, %d %B')"'' 24 "0, -108" "center" "top" {
              font_family = "${font_family} Medium";
              zindex = 10;
            })
            (mkLabel "$TIME" 96 "0, -140" "center" "top" {
              font_family = "${font_family} Semibold";
              zindex = 9;
            })
            (mkLabel "$DESC" 14 "0, 135" "center" "bottom" { font_family = "${font_family} Medium"; })
          ];

          image = [
            {
              monitor = "";
              path = "~/.face";
              size = 64;
              rounding = -1;
              border_size = 0;
              position = "0, 170";
              halign = "center";
              valign = "bottom";
            }
          ];

          input-field =
            with config.stylix.base16Scheme;
            mkForce [
              {
                inherit font_family;
                monitor = "";
                size = "225, 40";
                outline_thickness = 2;

                position = "0, 76";
                halign = "center";
                valign = "bottom";

                outer_color = "rgba(00000000)";
                inner_color = "rgba(00000000)";
                fail_color = "rgb(${base08})";
                check_color = "rgb(${base0A})";

                font_color = "rgba(${base05}BF)";
                font_size = 14;

                fade_on_empty = false;

                placeholder_text =
                  if config.modules.security.fprintd.enable then
                    "Enter Password or Scan Fingerprint"
                  else
                    "Enter Password";

                rounding =
                  mkForce
                    config.home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.decoration.rounding;

                fail_text = "<i>Try again</i>";
              }
            ];
        };
      };

      services.hypridle = mkIf cfg.hypridle.enable {
        enable = mkForce true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = cfg.hypridle.lockTimeout * 60;
              on-timeout = "hyprlock";
            }
            {
              timeout = cfg.hypridle.sleepTimeout * 60;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
