{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.libresprite;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.libresprite = {
    enable = mkEnableOption "Enable programs.libresprite";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libresprite ];
  };
}
