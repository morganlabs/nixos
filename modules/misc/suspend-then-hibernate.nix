{ config, lib, ... }:
with lib;
let
  cfg = config.modules.misc.suspend-then-hibernate;
in
{
  options.modules.misc.suspend-then-hibernate = {
    enable = mkEnableOption "Enable misc.suspend-then-hibernate";
    hibernate-delay = mkIntOption "How long to be suspended before hibernating (in minutes)" 60;
    suspend-state = mkStringOption "Which type of suspend to use (ex: s2idle, deep, etc.)" "s2idle";
    resume-device = mkStringOption "Which swap device to use to resume from in hibernation" "";
  };

  config = mkIf cfg.enable {
    services.logind = {
      lidSwitch = mkDefault "suspend-then-hibernate";
      powerKey = mkDefault "hibernate";
    };

    boot.kernelParams = mkAfter [
      "mem_sleep_default=${cfg.suspend-state}"
      "resume=${cfg.resume-device}"
      "rtc_cmos.use_acpi_alarm=1"
    ];

    systemd.sleep.extraConfig = mkForce ''
      HibernateDelaySec=${toString (cfg.hibernate-delay * 60)}
      HibernateOnACPower=true
      SuspendState=mem
    '';
  };
}
