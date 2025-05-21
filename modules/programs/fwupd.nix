{ config, lib, ... }:
let
  cfg = config.modules.programs.fwupd;
in
with lib;
{
  options.modules.programs.fwupd = {
    enable = mkEnableOption "Enable programs.fwupd";
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = mkForce true;
  };
}
