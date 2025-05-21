{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.cachix;
in
{
  options.modules.desktop.hyprland.cachix = {
    enable = mkEnableOption "Enable desktop.hyprland.cachix";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = mkAfter [ "https://hyprland.cachix.org" ];
      trusted-public-keys = mkAfter [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
