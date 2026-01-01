{ lib, ...}: with lib; {
  imports = [
    ./colorcolumn.nix
    ./line-numbers.nix
    ./nerd.nix
    ./no-line-wrap.nix
    ./signcolumn.nix
    ./swapfile.nix
    ./tabstop.nix
    ./termguicolors.nix
    ./undodir.nix
    ./updatetime.nix
    ./keymaps
  ];

  modules.programs.nvim.config = {
    colorcolumn.enable = mkForce true;
    nerd.enable = mkForce true;
    no-line-wrap.enable = mkForce true;
    signcolumn.enable = mkForce true;
    swapfile.enable = mkForce true;
    termguicolors.enable = mkForce true;
    undodir.enable = mkForce true;

    line-numbers = {
      nu = mkDefault true;
      rnu = mkDefault true;
    };
  };
}
