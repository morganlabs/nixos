{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.program.onlyoffice;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.program.onlyoffice = {
    enable = mkEnableOption "Enable program.onlyoffice";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ onlyoffice-desktopeditors ];
  };
}
