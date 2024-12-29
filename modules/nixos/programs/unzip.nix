{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.unzip;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.unzip = {
    enable = mkEnableOption "Enable programs.unzip";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ unzip ];
  };
}
