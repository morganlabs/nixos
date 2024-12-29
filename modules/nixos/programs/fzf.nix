{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.fzf;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.fzf = {
    enable = mkEnableOption "Enable programs.fzf";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.fzf.enable = true;
      programs.fzf.enable = true;
    };
  };
}
