{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.bat;
  aliases.cat = "${pkgs.bat}/bin/bat";
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.bat = {
    enable = mkEnableOption "Enable programs.bat";
    features.aliases.enable = mkBoolOption "Enable Aliases for all shells" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = mkMerge [
      {
        stylix.targets.bat.enable = true;
        programs.bat = {
          enable = true;
          config.style = "full";
        };
      }
      (mkIf cfg.features.aliases.enable {
        programs.zsh.shellAliases = aliases;
        programs.bash.shellAliases = aliases;
      })
    ];
  };
}
