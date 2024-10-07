{ config, lib, ... }:
with lib;
let
  cfg = config.roles.sound.pipewire;
in
{
  options.roles.sound.pipewire = {
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
