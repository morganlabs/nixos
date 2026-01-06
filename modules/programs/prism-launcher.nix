{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.prism-launcher;
in
{
  options.modules.programs.prism-launcher = {
    enable = mkEnableOption "Enable programs.prism-launcher";
  };

  config = mkIf cfg.enable {
    modules.programs.gamemode.enable = mkDefault true;

    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        additionalPrograms = [ ffmpeg ];

        jdks = [
          javaPackages.compiler.temurin-bin.jdk-21
        ];
      })
    ];
  };
}
