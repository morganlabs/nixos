# Morgan's NixOS Configurations

This is my repo full of my NixOS configurations.

## Mending

* Framework Laptop 13
* Ryzen 5 7640U
* 16GB (The 64GB kit I bought is borked, so will hopefully be upgrading soon)
* 2TB NVMe SSD
* 13.5" 2.2K 60Hz Display

# TODO

## Framework

- [x] `mkSystem`
- [x] Library helper functions
- [x] Home Manager
- [x] Configure git
- [x] Bootloader (Secure Boot)
- [x] Pick a kernel (probably linux-zen)
- [x] Networking+Firewall
- [x] Networking UI
- [x] Bluetooth
- [x] SSH
  - [x] Fail2Ban
  - [x] Endlessh
  - [ ] Only enable SSH when on home network? idk if thats a thing)
- [x] Agenix
- [ ] zsh
- [x] Nixvim
- [x] Keyring
- [x] Nix Optimisations

- [ ] LUKS with TPM
- [x] `nixos-hardware`/Hardware quirks
- [x] Hyprland setup
- [ ] Lockscreen
- [ ] Boot logo/animation (plymouth)
- [x] Battery optimizations/Power Management
  - [x] Low-power <=> high-performance toggle
- [x] Fingerprint
- [ ] Suspend (to RAM and to Disk after timeout)
- [ ] Lid Switch to Suspend
- [x] Btrfs
  - [ ]and Backups
- [x] Prism launcher
- [x] GPU stuff (OpenGL/CL)
- [ ] NordVPN
- [x] Auto-theme on wallpaper
- [x] Notification daemon
- [ ] Localsend
- [x] Brightness, audio, etc., functions + keys
- [x] Remap Caps Lock to Escape
- [ ] Theming (GNOME/Qt/Icons/etc.)
- [x] Touchpad
- [x] Fonts
- [x] Audio
- [ ] Printing
- [ ] EarlyOOM (TODO!: Research)
- [ ] Gaming optimizations
- [ ] Cachix (TODO!: Research)

## Servers

- [x] Minecraft Fabric server
  - [x] Mods/Resources/Shaders website
  - [x] Online admin/RCON panel
- [x] Navidrome
- [ ] Nextcloud
- [x] Dashboard
- [x] Traefik
- [ ] PiHole DNS
- [ ] Portainer
- [ ] Immich
- [ ] Off-site Backups
- [ ] Home Assistant
- [ ] OAuth SSO
