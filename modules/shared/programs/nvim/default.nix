{
  config,
  pkgs,
  lib,
  inputs,
  isDarwin,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim;

  nixvimModule =
    mkIfElse isDarwin inputs.nixvim.nixDarwinModules.nixvim
      inputs.nixvim.nixosModules.nixvim;

  platformConfigs = mkIfElse isDarwin (import ./darwin.nix { inherit cfg lib; }) (
    import ./linux.nix { inherit cfg lib; }
  );
in
{
  imports = [
    nixvimModule
    platformConfigs
    ./plugins
  ];

  options.modules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ripgrep ];
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      opts = import ./config/opts.nix config.lib;
      globals = import ./config/globals.nix;
      keymaps = import ./config/keymaps.nix;
      highlightOverride = import ./config/highlightOverrides.nix;
      autoCmd = import ./autoCmds;

      plugins = {
        fidget.enable = true;
        indent-blankline.enable = true;
      };
    };
  };
}
