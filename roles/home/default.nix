{ ... }:
{
  imports = [
    ./cmd/zsh.nix
    ./cmd/git.nix

    ./programs/kitty.nix

    ./desktop/hyprland/default.nix
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/waybar.nix
    ./desktop/rofi.nix
  ];
}
