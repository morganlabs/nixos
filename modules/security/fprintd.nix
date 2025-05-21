{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.security.fprintd;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.security.fprintd = {
    enable = mkEnableOption "Enable security.fprintd";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fprintd ];
    services.fprintd.enable = mkForce true;
  };
}
