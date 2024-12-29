defaultPlugins:
{ lib, pkgs, ... }:
{
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "personal" ];
  };

  programs.firefox.profiles.personal = {
    id = 0;
    name = "Personal";
    isDefault = true;
    extensions = defaultPlugins;
    settings = (import ../user.nix) // {
      "browser.uiCustomization.state" = import ../layout.nix;
    };

    bookmarks = with lib.firefox; [
      {
        toolbar = true;
        bookmarks = [ (mkBookmark "Profiles" "about:profiles") ];
      }
    ];

    search = {
      force = true;
      default = "Startpage";

      engines = {
        "Bing".metaData.hidden = true;
        "DuckDuckGo".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
        "Google".metaData.alias = "@g";

        "Startpage" = import ../engines/startpage.nix;
        "Nix Packages" = import ../engines/nixPackages.nix { inherit pkgs; };
        "NixOS Settings" = import ../engines/nixOSSettings.nix { inherit pkgs; };
        "Home Manager Settings" = import ../engines/homeManagerSettings.nix;
        "GitHub" = import ../engines/github.nix;
        "YouTube" = import ../engines/youtube.nix;
      };
    };
  };
}
