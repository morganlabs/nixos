{ ... }:
{
  imports = [
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/pfetch.nix
    ./programs/nvim
    ./programs/kitty.nix
    ./programs/betterbird.nix
    ./programs/1password.nix

    ./programs/vimv.nix
    ./programs/unzip.nix
    ./programs/man.nix
    ./programs/joshuto.nix
    ./programs/obsidian.nix
    ./programs/slack.nix

    ./programs/discord
    ./programs/firefox

    ./desktop/hyprland/default.nix
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/waybar.nix
    ./desktop/rofi.nix
    ./desktop/mako.nix

    ./games/minecraft.nix
  ];
}
