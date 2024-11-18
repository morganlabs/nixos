defaultPlugins:
{ lib, ... }:
{
  stylix.targets.firefox = {
    enable = true;
    profileNames = [ "college" ];
  };

  programs.firefox.profiles.college = {
    id = 1;
    name = "College";
    extensions = defaultPlugins;
    settings = (import ../user.nix) // {
      "browser.uiCustomization.state" = import ../layout.nix;
    };

    bookmarks = with lib.firefox; [
      {
        toolbar = true;
        bookmarks = [
          (mkBookmark "Profiles" "about:profiles")
          (mkBookmark "Profiles" "about:profiles")
          (mkBookmark "Classroom" "https://classroom.google.com")
          (mkBookmark "Drive" "https://drive.google.com")
          (mkBookmark "Moodle" "https://moodle.gllm.ac.uk")
          (mkBookmark "GitHub" "https://github.com")
        ];
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
