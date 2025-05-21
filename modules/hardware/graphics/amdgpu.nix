{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.hardware.graphics.amdgpu;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.hardware.graphics.amdgpu = {
    enable = mkEnableOption "Enable hardware.graphics.amdgpu";
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = mkBefore [ "amdgpu" ];
    services.xserver.videoDrivers = mkBefore [ "amdgpu" ];

    hardware = {
      graphics = {
        enable = mkForce true;
        enable32Bit = mkDefault true;
        extraPackages = with pkgs; mkBefore [ rocmPackages.clr.icd ];
      };

      amdgpu = {
        opencl.enable = mkForce true;
        amdvlk = {
          enable = mkForce true;
          support32Bit.enable = mkDefault true;
        };
      };
    };

    systemd.tmpfiles.rules = mkForce [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
