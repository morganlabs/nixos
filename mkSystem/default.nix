inputs: hostname: pretty-name: system: {
  "${hostname}" =
    let
      vars = import ../vars.nix // {
        inherit hostname pretty-name;
      };
      overlays = import ./overlays.nix inputs;

      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      myLib = import ../lib pkgs.lib;
      lib = pkgs.lib.extend (_: prev: prev // myLib);
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      specialArgs = { inherit vars inputs lib; };
      modules = [
        ./base/config.nix
        ./base/home.nix
        (../hosts + "/${hostname}/config.nix")
        ../modules
      ];
    };
}
