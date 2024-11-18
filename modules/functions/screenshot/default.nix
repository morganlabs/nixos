{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.functions.screenshot;
  screenshotWlr = pkgs.writeShellScriptBin "screenshot-wlr" (builtins.readFile ./screenshot-wlr.sh);
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.functions.screenshot = {
    enable = mkEnableOption "Enable functions.screenshot";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      screenshotWlr
      slurp
      grim
      jq
    ];

    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind =
      mkIf cfg.features.hyprland.enable
        [
          "$alt SHIFT, 1, exec, ${screenshotWlr}/bin/screenshot-wlr selection"
          "$alt SHIFT, 2, exec, ${screenshotWlr}/bin/screenshot-wlr window"
          "$alt SHIFT, 3, exec, ${screenshotWlr}/bin/screenshot-wlr all"
        ];
  };
}
