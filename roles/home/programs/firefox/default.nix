{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs.firefox;

  importProfile = path: (import path { inherit pkgs; });
in
{
  options.roles.programs.firefox = {
    enable = mkEnableOption "Enable Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles = {
        morgan = importProfile ./profiles/morgan.nix;
      };
    };
  };
}
