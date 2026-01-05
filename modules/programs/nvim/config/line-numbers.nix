{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.line-numbers;
in
{
  options.modules.programs.nvim.config.line-numbers = {
    nu = mkEnableOption "Make Neovim the EDITOR";
    rnu = mkEnableOption "Alias `nvim` to `vi` and `vim`";
  };

  config = {
    programs.nixvim.opts = {
      nu = mkForce cfg.nu;
      rnu = mkForce cfg.rnu;
    };
  };
}
