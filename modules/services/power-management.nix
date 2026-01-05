{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.services.power-management;
in
{
  options.modules.services.power-management = {
    enable = mkEnableOption "Enable services.power-management";
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;

    services.upower = {
      enable = mkForce true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 2;
      usePercentageForPolicy = true;
    };

    # services.auto-cpufreq = {
    #   enable = true;
    #
    #   settings = {
    #     charger = {
    #       governor = "performance";
    #       turbo = "auto";
    #       # For Ryzen + amd-pstate, this effectively gives you 100% performance.
    #     };
    #
    #     battery = {
    #       governor = "powersave";
    #       turbo = "auto"; # Still allows bursts when needed
    #       min_freq = 800; # kHz, adjust to your CPU; keep low
    #       max_freq = 2400; # moderate cap for balance
    #     };
    #   };
    # };
  };
}
