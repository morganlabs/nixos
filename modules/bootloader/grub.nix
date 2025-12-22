{ config, lib, ... }:
with lib;
let
  cfg = config.modules.bootloader.grub;
in
{
  options.modules.bootloader.grub = {
    enable = mkEnableOption "Enable bootloader.grub";
    device = mkStringOption "The Device for GRUB to use" "";
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      inherit (cfg) device;
      enable = mkForce true;
    };
  };
}
