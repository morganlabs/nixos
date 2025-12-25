{ config, lib, ... }:
with lib;
let
  cfg = config.modules.bootloader.systemd-boot;
in
{
  options.modules.bootloader.systemd-boot = {
    enable = mkEnableOption "Enable bootloader.systemd-boot";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = mkForce true;
      efi.canTouchEfiVariables = mkDefault true;
    };
  };
}
