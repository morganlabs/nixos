{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixosModules.decoration.stylix;
in
with lib;
{
  options.nixosModules.decoration.stylix = {
    enable = mkEnableOption "Enable decoration.stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ./wallpaper.jpg;
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
          monospace = mkFont monaspace "MonaspaceKr Nerd Font Mono";
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;
        };
    };
  };
}
