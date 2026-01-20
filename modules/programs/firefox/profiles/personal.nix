{
  config,
  lib,
  vars,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.firefox.profiles.personal;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.modules.programs.firefox.profiles.personal = {
    enable = mkEnableOption "Enable programs.firefox.profiles.personal";
    defaultProfile = mkBoolOption "Whether or not this profile is the default" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      programs.firefox.profiles.personal = {
        name = "Personal";
        isDefault = cfg.defaultProfile;

        settings = {
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = mkForce false;

          # DNS-over-HTTPS
          "network.trr.mode" = 3;
          "network.trr.uri" = "https://dns.quad9.net/dns-query";
          "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";

          # Disable password saving/autofill (handled by Bitwarden)
          "dom.forms.autocomplete.formautofill" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.autofillForms" = false;
          "signon.rememberSignons" = false;

          # Disable AI Slop
          "browser.ml.chat.enabled" = false;
          "browser.ml.enable" = false;
          "browser.ml.linkPreview.enabled" = false;
          "browser.ml.pageAssist.enabled" = false;
          "browser.ml.smartAssist.enabled" = false;
          "extensions.ml.enabled" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "browser.search.visualSearch.featureGate" = false;
          "browser.urlbar.quicksuggest.mlEnabled" = false;
          "pdfjs.enableAltText" = false;
          "places.semanticHistory.featureGate" = false;
          "sidebar.revamp" = false;

          # Locale
          "intl.locale.requested" = "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.locale-weather-config" = "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.sections.contextualAds.locale-config" = "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.sections.locale-content-config" = "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.sections.personalization.inferred.locale-config" =
            "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.thumbsUpDown.locale-thumbs-config" = "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.topicLabels.locale-topic-label-config" =
            "en-GB";
          "browser.newtabpage.activity-stream.discoverystream.topicSelection.locale-topics-config" = "en-GB";

          # Downloads
          "browser.download.always_ask_before_handling_new_types" = mkForce false;
          "browser.download.useDownloadDir" = mkForce true;

          # Extensions
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.activity-stream.asrouterExperimentEnabled" = false;
          "ui.recommendations" = false;

          # UI Tweaks!
          "sidebar.verticalTabs" = true;
          "general.autoScroll" = true;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.tabs.loadInBackground" = true;
          "browser.uiCustomization.state" =
            ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","customizableui-special-spring1","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","urlbar-container","vertical-spacer","customizableui-special-spring2","downloads-button","fxa-toolbar-menu-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","screenshot-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":23,"newElementCount":17}'';
        };

        arkenfox = {
          enable = true;
          "0000".enable = true;
          "0100".enable = true;
          "0200".enable = true;
          "0300".enable = true;
          "0400".enable = true;
          "0600".enable = true;
          "0700".enable = true;
          "0800".enable = true;
          "0900".enable = true;
          "1000".enable = true;
          "1200".enable = true;
          "1600".enable = true;
          "1700".enable = true;
          "2000".enable = true;
          "2400".enable = true;
          "2600".enable = true;
          "2700".enable = true;
          "2800".enable = true;
          "4000".enable = true;
          "4500".enable = true;
          "5000".enable = true;
          "5500".enable = true;
          "6000".enable = true;
          "7000".enable = true;
          "8000".enable = true;
          "8500".enable = true;
        };

        bookmarks = {
          force = true;
          settings = with lib.firefox; [
            (mkBookmark "GitHub" "https://github.com" { })
            (mkBookmark "Music" "https://music.morganlabs.dev" { })
            (mkBookmarkFolder "Server" true [
              (mkBookmarkFolder "Minecraft" true [
                (mkBookmark "Catalogue" "https://mc.morganlabs.dev/catalogue" { })
                (mkBookmark "Dashboard" "https://mc.morganlabs.dev/dash" { })
              ])
              (mkBookmark "Lidarr" "https://lidarr.morganlabs.dev" { })
              (mkBookmark "Traefik" "https://traefik.morganlabs.dev" { })
              (mkBookmark "Status" "https://status.morganlabs.dev" { })
            ])
          ];
        };

        extensions.packages =
          with inputs.firefox-addons.packages.${vars.system};
          ([ ] ++ mkIfList config.modules.programs.bitwarden.enable [ bitwarden ]);

        search = {
          default = "kagi";
          force = true;

          engines = with lib.firefox; {
            kagi = (
              mkSearchEngine "Kagi" "https://kagi.com/search?q={searchTerms}" "@k" "https://kagi.com/favicon.ico"
            );

            nixpkgs = (
              mkSearchEngine "Nix Packages" "https://search.nixos.org/packages?type=packages&query={searchTerms}"
                "@np"
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"
            );
            nixos-settings = (
              mkSearchEngine "NixOS Settings"
                "https://search.nixos.org/options?channel=unstable&query={searchTerms}"
                "@ns"
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"
            );
            nixos-wiki = (
              mkSearchEngine "NixOS Wiki" "https://wiki.nixos.org/w/index.php?search={searchTerms}" "@nw"
                "https://wiki.nixos.org/favicon.ico"
            );
            home-manager-settings = (
              mkSearchEngine "Home Manager Settings"
                "https://home-manager-options.extranix.com/?release=master&query={searchTerms}"
                "@hm"
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"
            );

            bing.metaData.hidden = true;
            ddg.metaData.hidden = true;
            ebay.metaData.hidden = true;
            wiki.metaData.hidden = true;
            google.metaData.alias = "@g";
            bookmarks.metaData.alias = "@b";
          };
        };
      };
    };
  };
}
