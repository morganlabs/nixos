{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.connectivity;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.connectivity = {
    enable = mkEnableOption "Enable bundles.connectivity";
  };

  config = mkIf cfg.enable {
    modules.connectivity = {
      networkmanager.enable = mkDefault true;
      bluetooth.enable = mkDefault true;
      firewall.enable = mkDefault true;
      ssh.enable = mkDefault true;
    };
  };
}
