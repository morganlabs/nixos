{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.decoration.stylix;
in
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
      enable = mkForce true;
      image = ./wallpaper.jpeg;

      targets = {
        nixos-icons.enable = mkDefault true;
        gtk.enable = mkDefault true;
        console.enable = mkDefault true;
      };

      fonts =
        let
          mkFont = package: name: { inherit package name; };
          appleFonts = inputs.apple-fonts.packages.${pkgs.system};
        in
        {
          monospace = mkFont pkgs.nerd-fonts.monaspace "MonaspiceKr Nerd Font Mono";
          serif = mkFont appleFonts.ny "New York";
          sansSerif = mkFont appleFonts.sf-pro "SF Pro Text";
          emoji = mkFont pkgs.noto-fonts-color-emoji "NotoColorEmoji";
        };
    };

    home-manager.users.${vars.user.username} = {
      stylix.targets.xresources.enable = mkDefault true;
    };
  };
}
