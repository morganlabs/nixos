{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.firefox;
in
{
  options.roles.firefox = {
    enable = mkEnableOption "Enable Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.morgan = {
        isDefault = true;
	name = "Morgan";

	settings.extensions.autoDisableScopes = 0;
	extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          onepassword-password-manager
          ublock-origin
          sponsorblock
          youtube-shorts-block
        ];

	extraConfig = builtins.readFile ./user.js;
	
	search = {
	  force = true;
	  default = "Startpage";

	  engines = {
            "Bing".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias

            "Startpage" = {
              urls = [{
                template = "https://www.startpage.com/sp/search";
                params = [
                  { name = "query"; value = "{searchTerms}"; }
                  { name = "prfe"; value = "a351e5297847bd67e55cdd854b1318233cfdfacb4cb4a1e916118fecd03dbc505f3aa87e982f8a40c1a5bb9090cfcb036a507c59f34c6cc53de47effe79e3a3cd6e48a074bba96167b5c0dba"; }
                ];
              }];
        
              # icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@sp" ];
            };

            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
        
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
        
            "NixOS Settings" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
        
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Home Manager Settings" = {
              urls = [{
                template = "https://home-manager-options.extranix.com";
                params = [
                  { name = "release"; value = "master"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
        
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hs" ];
            };
          };
        };
      };
    };
  };
}
