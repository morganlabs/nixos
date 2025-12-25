{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.node;
in
{
  options.modules.programs.node = {
    enable = mkEnableOption "Enable programs.node";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      bun
    ];
  };
}
