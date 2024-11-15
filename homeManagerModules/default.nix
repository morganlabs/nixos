{ inputs, ... }:
{
  imports = with inputs; [
    ./base/xdgUserDirs.nix

    ./desktop/hyprland

    ./programs/nvim
    nixvim.homeManagerModules.nixvim
    ./programs/zsh
    ./programs/waybar
    ./programs/rofi
    ./programs/firefox
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/pfetch.nix
    ./programs/bat.nix
    ./programs/btop.nix
    ./programs/eza.nix
    ./programs/fzf.nix
  ];
}
