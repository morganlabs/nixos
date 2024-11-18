{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.sound.pipewire;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.sound.pipewire = {
    enable = mkEnableOption "Enable sound.pipewire";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
