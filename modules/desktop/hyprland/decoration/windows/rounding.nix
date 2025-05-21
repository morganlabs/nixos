{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.decoration.windows.rounding;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.decoration.windows.rounding = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.decoration.windows.rounding";
    amount = mkIntOption "Amount to round the windows by" 8;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings = {
      decoration.rounding = mkForce cfg.amount;
      workspace = mkAfter [ "f[true], rounding:0" ];
    };
  };
}
