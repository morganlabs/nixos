{ pkgs }:
{
  urls = [
    {
      template = "https://home-manager-options.extranix.com";
      params = [
        {
          name = "release";
          value = "master";
        }
        {
          name = "query";
          value = "{searchTerms}";
        }
      ];
    }
  ];

  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  definedAliases = [ "@hm" ];
}
