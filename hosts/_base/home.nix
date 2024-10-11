{
  inputs,
  user,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
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
  };

  roles = {
    programs = {
      kitty.enable = true;
      firefox.enable = true;
      betterbird.enable = true;
      _1password.enable = true;
      discord.enable = true;
      git.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      pfetch.enable = true;
      vimv.enable = true;
      unzip.enable = true;
      man.enable = true;
      joshuto.enable = true;
      obsidian.enable = true;
      slack.enable = true;
    };

    desktop = {
      hyprland = {
        enable = true;

        extra.binds = [
          "bind = $mainMod, code:49, togglespecialworkspace, discord"
          "bind = ALT, code:49, togglespecialworkspace, slack"
          "bind = Control_L, code:49, togglespecialworkspace, mail"
        ];

        features = {
          startOnLogin.enable = true;
          screenshot.enable = true;
          autostart = [
            "exec-once = systemctl --user start plasma-polkit-agent"
            "exec-once = [workspace 1 silent] kitty"
            "exec-once = [workspace 2 silent] firefox"
            "exec-once = [workspace 3 silent] obsidian"
            "exec-once = [workspace special:discord silent] discord"
            "exec-once = [workspace special:slack silent] slack"
            "exec-once = [workspace special:mail silent] betterbird"
          ];
        };
      };

      hypridle.enable = true;
      hyprlock.enable = true;
      rofi.enable = true;
      mako.enable = true;
      waybar = {
        enable = true;
        modules = {
          volume.enable = true;
          network.enable = true;
          bluetooth.enable = true;
          tray.enable = true;
        };
      };
    };
  };

  programs.home-manager.enable = true;
}
