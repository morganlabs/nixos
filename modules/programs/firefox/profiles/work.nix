defaultPlugins:
{ lib, ... }:
{
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "work" ];
  };

  programs.firefox.profiles.work = {
    id = 2;
    name = "Work";
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
        "GitHub" = import ../engines/github.nix;
      };
    };
  };
}
