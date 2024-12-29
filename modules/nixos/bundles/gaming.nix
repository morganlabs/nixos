{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.gaming;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.gaming = {
    enable = mkEnableOption "Enable bundles.gaming";
  };

  config = mkIf cfg.enable {
    modules.programs = {
      steam.enable = mkDefault true;
    };
  };
}
