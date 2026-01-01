{ lib, ...}: with lib; {
  imports = [
    ./append-line.nix
    ./centred-search-cursor.nix
    ./explorer.nix
    ./jump-page.nix
    ./leader.nix
    ./make-file-exe.nix
    ./move-lines.nix
    ./replace-word.nix
    ./system-clipboard.nix
  ];

  modules.programs.nvim.config.keymaps = {
    append-line.enable = mkDefault true;
    centred-search-cursor.enable = mkDefault true;
    explorer.enable = mkDefault true;
    jump-page.enable = mkDefault true;
    leader.enable = mkDefault true;
    make-file-exe.enable = mkDefault true;
    move-lines.enable = mkDefault true;
    replace-word.enable = mkDefault true;
    system-clipboard.enable = mkDefault true;
  };
}
