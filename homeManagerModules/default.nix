{ inputs, ... }:
{
  imports = with inputs; [
    ./base/xdgUserDirs.nix

    ./desktop/hyprland

    ./programs/nvim
    nixvim.homeManagerModules.nixvim
    ./programs/zsh
    ./programs/firefox
    ./programs/git.nix
    ./programs/kitty.nix
  ];
}
