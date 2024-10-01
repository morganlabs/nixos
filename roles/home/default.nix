{ ... }:
{
  imports = [
    ./cmd/zsh.nix
    ./cmd/git.nix
    ./cmd/nvim

    ./programs/kitty.nix
    ./programs/firefox

    ./desktop/hyprland/default.nix
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/waybar.nix
    ./desktop/rofi.nix
  ];
}
