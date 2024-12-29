{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.onlyoffice;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.onlyoffice = {
    enable = mkEnableOption "Enable programs.onlyoffice";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ onlyoffice-desktopeditors ];
  };
}
