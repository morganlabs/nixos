{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.eza;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.eza = {
    enable = mkEnableOption "Enable programs.eza";
    replaceLs = mkBoolOption "Replace `ls`" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      home.shellAliases.ls = mkIf cfg.replaceLs "eza -b -h --long --all --group-directories-first";
      programs.eza = {
        enable = true;
        git = true;
        colors = "auto";
        icons = "auto";
      };
    };
  };
}
