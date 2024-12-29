{
  urls = [
    {
      template = "https://github.com/search";
      params = [
        {
          name = "q";
          value = "{searchTerms}";
        }
        {
          name = "type";
          value = "repositories";
        }
      ];
    }
  ];

  iconUpdateURL = "https://github.githubassets.com/favicons/favicon.png";
  definedAliases = [ "@gh" ];
}
