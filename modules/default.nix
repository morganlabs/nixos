{
  imports = [
    ./boot/plymouth.nix
    ./boot/systemd-boot.nix

    ./decoration/stylix

    ./desktop/hyprland

    ./misc/aliases.nix
    ./misc/autologin.nix
    ./misc/xdgUserDirs.nix
    ./misc/cursor.nix
    ./misc/suspend-then-hibernate.nix

    ./hardware/usb-automount.nix
    ./hardware/power-management.nix
    ./hardware/audio/pipewire.nix
    ./hardware/graphics/amdgpu.nix

    ./programs/shells/zsh
    ./programs/nvim
    ./programs/rofi
    ./programs/waybar
    ./programs/zen-browser
    ./programs/steam
    ./programs/bat.nix
    ./programs/btop.nix
    ./programs/eza.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/fwupd.nix
    ./programs/spotify.nix
    ./programs/cider2.nix
    ./programs/obsidian.nix
    ./programs/bitwarden.nix

    ./security/sudo-rs.nix
    ./security/fprintd.nix

    ./connectivity/networkmanager.nix
    ./connectivity/bluetooth.nix
    ./connectivity/printing.nix
  ];
}
