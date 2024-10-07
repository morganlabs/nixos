{ config, lib, ... }:
with lib;
let
  cfg = config.roles.bootloader.grub;
in
{
  options.roles.bootloader.grub = {
    enable = mkEnableOption "Enable the GRUB bootloader";

    configurationLimit = mkOption {
      type = types.int;
      description = "The configuration limit";
      default = 10;
    };

    features.osProber.enable = mkOption {
      type = types.bool;
      description = "Enable OS Prober";
      default = false;
    };
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
