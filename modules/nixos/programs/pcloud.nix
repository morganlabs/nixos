{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.pcloud;

  patchelfFixes = pkgs.patchelfUnstable.overrideAttrs (
    _finalAttrs: _previousAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "Patryk27";
        repo = "patchelf";
        rev = "527926dd9d7f1468aa12f56afe6dcc976941fedb";
        sha256 = "sha256-3I089F2kgGMidR4hntxz5CKzZh5xoiUwUsUwLFUEXqE=";
      };
    }
  );

  pcloudPatched = pkgs.pcloud.overrideAttrs (
    _finalAttrs: previousAttrs: {
      nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ patchelfFixes ];
    }
  );
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.pcloud = {
    enable = mkEnableOption "Enable programs.pcloud";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pcloudPatched ];
  };
}
