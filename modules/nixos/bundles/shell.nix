{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.shell;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.shell = {
    enable = mkEnableOption "Enable bundles.shell";
  };

  config = mkIf cfg.enable {
    modules = {
      shells.zsh.enable = mkDefault true;
      security.sudo.enable = mkDefault true;
      programs = {
        nvim.enable = mkDefault true;
        btop.enable = mkDefault true;
        eza.enable = mkDefault true;
        bat.enable = mkDefault true;
        git.enable = mkDefault true;
        fzf.enable = mkDefault true;
        pfetch.enable = mkDefault true;
        unzip.enable = mkDefault true;
        tmux.enable = mkDefault true;
      };
    };
  };
}
