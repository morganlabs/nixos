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
  cfg = config.modules.programs.stylix;

  defaultWallpaper = ./wallpaper.png;
  isDefaultWallpaper = cfg.wallpaper == defaultWallpaper;

  mkFont = name: package: { inherit name package; };
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.modules.programs.stylix = {
    enable = mkEnableOption "Enable programs.stylix";

    wallpaper = mkPathOption "The path to your wallpaper" defaultWallpaper;
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = mkForce true;
      polarity = mkForce "dark";

      cursor = {
        package = pkgs.rose-pine-hyprcursor;
        name = "BreezX-RosePine-Linux";
        size = 24;
      };

      fonts =
        with pkgs;
        with inputs.apple-fonts.packages.${vars.system};
        {
          serif = mkFont "NewYork Nerd Font" ny-nerd;
          sansSerif = mkFont "SFProText Nerd Font" sf-pro-nerd;
          monospace = mkFont "MonaspiceNe Nerd Font Mono" nerd-fonts.monaspace;
          emoji = mkFont "Noto Color Emoji" noto-fonts-color-emoji;
        };
    }
    //
      mkIfElse isDefaultWallpaper
        {
          # If using a default wallpaper, define a theme.
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
          image = cfg.wallpaper;
        }
        {
          # If using a custom wallpaper, define a theme.
          image = cfg.wallpaper;
        };

    home-manager.users.${vars.user.username} = { };
  };
}
