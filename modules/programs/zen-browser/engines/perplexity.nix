{
  urls = [
    {
      template = "https://perplexity.ai";
      params = [
        {
          name = "q";
          value = "{searchTerms}";
        }
      ];
    }
  ];

  icon = "https://www.perplexity.ai/favicon.ico";
  definedAliases = [ "@p" ];
}
