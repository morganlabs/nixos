{ config, lib, ... }:
with lib;
let
  cfg = config.modules.boot.plymouth;
in
{
  options.modules.boot.plymouth = {
    enable = mkEnableOption "Enable boot.plymouth";
  };

  config = mkIf cfg.enable {
    stylix.targets.plymouth = {
      enable = mkForce true;
      logoAnimated = mkForce false;
    };

    boot = {
      plymouth.enable = mkForce true;

      consoleLogLevel = mkDefault 0;
      initrd = {
        verbose = mkDefault false;
        systemd.enable = mkForce true;
      };

      kernelParams = mkBefore [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
