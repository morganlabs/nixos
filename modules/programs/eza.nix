{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.eza;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.eza = {
    enable = mkEnableOption "Enable programs.eza";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      programs.eza = {
        enable = true;
        git = true;
        colors = "auto";
        icons = "auto";
        extraOptions = [
          "-b"
          "-h"
          "--long"
          "--all"
          "--group-directories-first"
        ];
      };
    };
  };
}
