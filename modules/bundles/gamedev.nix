{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.gamedev;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.gamedev = {
    enable = mkEnableOption "Enable bundles.gamedev";
  };

  config = mkIf cfg.enable {
    modules.programs = {
      godot.enable = true;
      libresprite.enable = true;
    };
  };
}
