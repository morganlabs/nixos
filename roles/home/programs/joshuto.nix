{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.joshuto;
in
{
  options.roles.programs.joshuto = {
    enable = mkEnableOption "Enable joshuto";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ joshuto ];
  };
}
