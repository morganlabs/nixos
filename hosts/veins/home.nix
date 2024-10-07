{
  pkgs,
  inputs,
  user,
  ...
}:
{
  imports = [
    ../../roles/home
    inputs.nix-colors.homeManagerModules.default
  ];

  # https://github.com/tinted-theming/base16-schemes/blob/main/gruvbox-dark-medium.yaml
  # base00: #282828 # ----
  # base01: #3c3836 # ---
  # base02: #504945 # --
  # base03: #665c54 # -
  # base04: #bdae93 # +
  # base05: #d5c4a1 # ++
  # base06: #ebdbb2 # +++
  # base07: #fbf1c7 # ++++
  # base08: #fb4934 # red
  # base09: #fe8019 # orange
  # base0A: #fabd2f # yellow
  # base0B: #b8bb26 # green
  # base0C: #8ec07c # aqua/cyan
  # base0D: #83a598 # blue
  # base0E: #d3869b # purple
  # base0F: #d65d0e # brown
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";

    packages = with pkgs; [
      # vimv
      # unzip
      # man
      # wl-clipboard

      discord
      # element
      # joshuto
      # nextcloud-client
      # obsidian
      # _1password
      # _1password-gui
    ];
  };

  roles = {
    desktop.windowManager.hyprland.enable = true;

    programs = {
      kitty.enable = true;
      firefox.enable = true;
      betterbird.enable = true;
    };

    cmd = {
      nvim.enable = true;
      zsh.enable = true;
    };

    desktop.waybar.modules = {
      volume.enable = true;
      brightness.enable = true;
      network.enable = true;
      bluetooth.enable = true;
      battery.enable = true;
      tray.enable = true;
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
