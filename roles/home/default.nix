{ ... }:
{
  imports = [
    ./cmd/zsh.nix
    ./cmd/git.nix
    ./cmd/pfetch.nix
    ./cmd/nvim

    ./programs/kitty.nix
    ./programs/betterbird.nix
    ./programs/1password.nix
    ./programs/discord
    ./programs/firefox

    ./desktop/hyprland/default.nix
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/waybar.nix
    ./desktop/rofi.nix

    ./games/minecraft.nix
  ];
}
