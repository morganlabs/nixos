{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lint;
in
{
  imports = [
    ./vale.nix
    ./gdlint.nix
    ./deadnix.nix
    ./eslint_d.nix
  ];

  options.modules.programs.nvim.plugins.lint = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lint";
  };

  config = mkIf cfg.enable {
    modules.programs.nvim.plugins.lint = {
      vale.enable = mkDefault true;
      gdlint.enable = mkDefault true;
      deadnix.enable = mkDefault true;
      eslint_d.enable = mkDefault true;
    };

    programs.nixvim.plugins.lint = {
      enable = mkForce true;

      autoCmd = {
        event = mkForce "BufWritePost";
        callback.__raw = ''
          function()
            require('lint').try_lint()
          end
        '';
      };
    };
  };
}
