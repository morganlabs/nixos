{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.bootloader.lanzaboote;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.modules.bootloader.lanzaboote = {
    enable = mkEnableOption "Enable bootloader.lanzaboote";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sbctl ];

    modules.bootloader.systemd-boot.enable = mkForce false;

    boot.lanzaboote = {
      enable = mkForce true;
      autoGenerateKeys.enable = mkForce true;
      autoEnrollKeys = {
        enable = mkForce true;
        autoReboot = mkForce true;
      };
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
