{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.pipewire;
in
{
  options.roles.pipewire = {
    enable = mkEnableOption "Pipewire";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
