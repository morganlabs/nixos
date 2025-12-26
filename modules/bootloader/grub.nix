{ config, lib, ... }:
with lib;
let
  cfg = config.modules.bootloader.grub;
in
{
  options.modules.bootloader.grub = {
    enable = mkEnableOption "Enable bootloader.grub";
    devices = mkListOption "str" "The Devices for GRUB to use" [];
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      inherit (cfg) devices;
      enable = mkForce true;
    };
  };
}
