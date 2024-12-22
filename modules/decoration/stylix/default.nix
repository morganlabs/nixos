{
  config,
  lib,
  inputs,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.modules.decoration.stylix;
in
with lib;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  options.modules.decoration.stylix = {
    enable = mkEnableOption "Enable decoration.stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ./wallpaper.png;
      polarity = "dark";
      autoEnable = false;

      opacity.terminal = 0.8;

      targets = {
        nixos-icons.enable = true;
        console.enable = true;
        gnome.enable = true;
        gtk.enable = true;
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      fonts =
        let
          monaspace = pkgs.nerdfonts.override { fonts = [ "Monaspace" ]; };
          mkFont = package: name: { inherit package name; };
        in
        {
          monospace = mkFont monaspace "MonaspiceKr Nerd Font Mono";
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;
        };
    };

    home-manager.users.${vars.user.username}.stylix.targets = {
      xresources.enable = true;
    };
  };
}
