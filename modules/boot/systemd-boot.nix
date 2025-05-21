{ config, lib, ... }:
with lib;
let
  cfg = config.modules.boot.systemd-boot;
in
{
  options.modules.boot.systemd-boot = {
    enable = mkEnableOption "Enable boot.systemd-boot";
    timeout = mkIntOption "The timeout of the bootloader (If 0, hold space to show generations)" 0;
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = mkForce true;
      timeout = mkForce cfg.timeout;
      efi.canTouchEfiVariables = mkDefault true;
    };
  };
}
