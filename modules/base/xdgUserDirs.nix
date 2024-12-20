{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.base.xdgUserDirs;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.base.xdgUserDirs = {
    enable = mkEnableOption "Enable base.xdgUserDirs";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} =
      { config, ... }:
      {
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
  };
}
