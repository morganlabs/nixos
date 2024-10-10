{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.sound.noisetorch;
in
{
  options.roles.sound.noisetorch = {
    enable = mkEnableOption "Enable NoiseTorch";
  };

  config = mkIf cfg.enable {
    programs.noisetorch.enable = true;
  };
}
