{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.grub;
in
{
  options.roles.grub = {
    enable = mkEnableOption "Enable the GRUB bootloader";

    configurationLimit = mkOption {
      type = types.int;
      description = "The configuration limit";
      default = 10;
    };

    useOSProber = mkOption {
      type = types.bool;
      description = "The configuration limit";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        inherit (cfg) useOSProber configurationLimit;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
