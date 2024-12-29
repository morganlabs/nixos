{
  urls = [
    {
      template = "https://www.youtube.com/results";
      params = [
        {
          name = "search_query";
          value = "{searchTerms}";
        }
      ];
    }
  ];

  iconUpdateURL = "https://www.youtube.com/s/desktop/508deff1/img/logos/favicon_96x96.png";
  definedAliases = [ "@yt" ];
}
