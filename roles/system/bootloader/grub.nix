{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.bootloader.grub;
in
{
  options.roles.bootloader.grub = {
    enable = mkEnableOption "Enable the GRUB bootloader";
    configurationLimit = mkOptionInt "The configuration limit" 10;
    features.osProber.enable = mkOptionBool "Enable OS Prober" false;
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub = {
        inherit (cfg) configurationLimit;
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = cfg.features.osProber.enable;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
