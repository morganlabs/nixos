{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.mako;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.mako = {
    enable = mkEnableOption "Enable programs.mako";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      home.packages = with pkgs; [ libnotify ];
      stylix.targets.mako.enable = true;

      services.mako = {
        enable = true;

        font = mkForce "MonaspiceNe Nerd Font Mono 14";
        format = ''<span font="10">%a</span>\n<b>%s</b>\n<span font="12">%b</span>'';
        layer = "overlay";
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
  };
}
