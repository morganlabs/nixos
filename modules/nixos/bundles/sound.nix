{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.sound;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.sound = {
    enable = mkEnableOption "Enable bundles.sound";
  };

  config = mkIf cfg.enable {
    modules.sound = {
      pipewire.enable = mkDefault true;
      noisetorch.enable = mkDefault true;
    };
  };
}
