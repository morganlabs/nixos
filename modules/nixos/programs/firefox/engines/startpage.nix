{
  urls = [
    {
      template = "https://www.startpage.com/sp/search";
      params = [
        {
          name = "query";
          value = "{searchTerms}";
        }
        {
          name = "prfe";
          value = "a351e5297847bd67e55cdd854b1318233cfdfacb4cb4a1e916118fecd03dbc505f3aa87e982f8a40c1a5bb9090cfcb036a507c59f34c6cc53de47effe79e3a3cd6e48a074bba96167b5c0dba";
        }
      ];
    }
  ];

  iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon-96x96.png";
  definedAliases = [ "@sp" ];
}
