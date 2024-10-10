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
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";

    packages = with pkgs; [
      # vimv
      # unzip
      # man
      # wl-clipboard
      # element
      # joshuto
      # nextcloud-client
      # obsidian
    ];
  };

  roles = {
    desktop.windowManager.hyprland.enable = true;

    programs = {
      kitty.enable = true;
      firefox.enable = true;
      betterbird.enable = true;
      _1password.enable = true;
      discord.enable = true;
    };

    cmd = {
      git.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      pfetch.enable = true;
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
}
