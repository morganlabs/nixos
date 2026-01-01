{ lib, ...}: with lib; {
  imports = [
    ./line-numbers.nix
    ./undodir.nix
    ./swapfile.nix
    ./colorcolumn.nix
  ];

  modules.programs.nvim.config = {
    undodir.enable = mkDefault true;
    swapfile.enable = mkDefault true;
    colorcolumn.enable = mkDefault true;

    line-numbers = {
      nu = mkDefault true;
      rnu = mkDefault true;
    };
  };
}
