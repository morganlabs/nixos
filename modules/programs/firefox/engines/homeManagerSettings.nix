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

  iconUpdateURL = "https://home-manager-options.extranix.com/images/favicon.png";
  definedAliases = [ "@hm" ];
}
