{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.misc.xdgUserDirs;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.misc.xdgUserDirs = {
    enable = mkEnableOption "Enable misc.xdgUserDirs";
    usingWindowManager = mkBoolOption "Are you using a Window Manager?" false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} =
      { config, ... }:
      {
        xdg.userDirs =
          let
            mkUserDir = dirName: mkForce "${config.home.homeDirectory}/${dirName}";
          in
          {
            enable = mkForce true;
            createDirectories = mkForce true;

            templates = mkUserDir ".templates";
            desktop = mkUserDir (mkIfStr cfg.usingWindowManager "desktop");
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
