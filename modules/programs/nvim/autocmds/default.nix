{ lib, ... }: with lib; {
    imports = [
      ./highlight-on-yank.nix
    ];

    modules.programs.nvim.autocmds = {
      highlight-on-yank.enable = mkDefault true;
    };
}
