{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.programs.bat;
  aliases.cat = "${pkgs.bat}/bin/bat";
in
with lib;
{
  options.homeManagerModules.programs.bat = {
    enable = mkEnableOption "Enable programs.bat";
    features.aliases.enable = mkBoolOption "Enable Aliases for all shells" true;
  };

  config = mkIf cfg.enable (
    {
      stylix.targets.bat.enable = true;
      programs.bat = {
        enable = true;
        config = {
          style = "full";
          theme = "base16";
        };
      };
    }
    // (mkIf cfg.features.aliases.enable {
      programs.zsh.shellAliases = mkIf osConfig.programs.zsh.enable aliases;
      programs.bash.shellAliases = mkIf osConfig.programs.bash.enable aliases;
    })
  );
}
