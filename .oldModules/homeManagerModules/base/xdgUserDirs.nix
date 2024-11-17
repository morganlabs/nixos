{ config, lib, ... }:
let
  cfg = config.homeManagerModules.base.xdgUserDirs;
in
with lib;
{
  options.homeManagerModules.base.xdgUserDirs = {
    enable = mkEnableOption "Enable base.xdgUserDirs";
  };

  config = mkIf cfg.enable {
    xdg.userDirs =
      let
        mkUserDir = dirName: "${config.home.homeDirectory}/${dirName}";
      in
      {
        enable = true;
        createDirectories = true;
        desktop = mkUserDir ""; # Just use the Home directory
        templates = mkUserDir ".templates";
        documents = mkUserDir "documents";
        download = mkUserDir "downloads";
        music = mkUserDir "music";
        pictures = mkUserDir "pictures";
        publicShare = mkUserDir "public";
        videos = mkUserDir "videos";
      };
  };
}
