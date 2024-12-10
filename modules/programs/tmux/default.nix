{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.tmux;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.tmux = {
    enable = mkEnableOption "Enable programs.tmux";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      programs.tmux = {
        enable = true;
        escapeTime = 0;
        terminal = "tmux-256color";
        prefix = "C-f";
        mouse = false;
        baseIndex = 1;

        extraConfig = import ./config.nix;
      };
    };
  };
}
