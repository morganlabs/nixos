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

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";

    packages = with pkgs; [
      # vimv
      # unzip
      # man
      # wl-clipboard

      # pavucontrol
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
    nvim.enable = true;
    zsh.enable = true;

    hyprland.enable = true;
    kitty.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
