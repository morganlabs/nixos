{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs._1password;
in
{
  options.roles.programs._1password = {
    enable = mkEnableOption "Enable 1Password";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password
      _1password-gui
    ];
  };
}
