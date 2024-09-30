{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.networkmanager;
in
{
  options.roles.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
