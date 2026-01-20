name: template: alias: icon: {
  inherit name icon;
  urls = [ { inherit template; } ];
  definedAliases = if builtins.isList alias then alias else [ alias ];
}
