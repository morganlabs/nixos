inputs: hostname: prettyName: system: {
  "${hostname}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      (../hosts/${hostname}/config.nix)
    ];
  };
}
