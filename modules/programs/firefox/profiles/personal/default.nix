defaultPlugins:
{ pkgs, ... }:
{
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "personal" ];
  };

  programs.firefox.profiles.personal = {
    name = "Personal";
    isDefault = true;
    settings = (
      (import ../../user.nix) true {
        "browser.uiCustomization.state" = import ./layout.nix;
      }
    );

    extensions =
      with pkgs.nur.repos.rycee.firefox-addons;
      [
        sponsorblock
        youtube-shorts-block
      ]
      ++ defaultPlugins;

    search = {
      force = true;
      default = "Startpage";

      engines = {
        "Bing".metaData.hidden = true;
        "DuckDuckGo".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
        "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias

        "Startpage" = import ../../engines/startpage.nix;
        "Nix Packages" = import ../../engines/nixPackages.nix { inherit pkgs; };
        "NixOS Settings" = import ../../engines/nixOSSettings.nix { inherit pkgs; };
        "Home Manager Settings" = import ../../engines/homeManagerSettings.nix;
        "GitHub" = import ../../engines/github.nix;
        "YouTube" = import ../../engines/youtube.nix;
      };
    };
  };
}
