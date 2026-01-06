{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.steam;
in
{
  options.modules.programs.steam = {
    enable = mkEnableOption "Enable programs.steam";
  };

  config = mkIf cfg.enable {
    modules.programs.gamemode.enable = mkDefault true;

    programs.steam = {
      enable = mkForce true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };
}
