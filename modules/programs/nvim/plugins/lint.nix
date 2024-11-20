{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      deadnix
      eslint_d
      vale
      gdtoolkit_4
    ];

    plugins.lint = {
      enable = true;

      autoCmd = {
        event = "BufWritePost";
        callback.__raw = ''
          function()
            require('lint').try_lint()
          end
        '';
      };

      lintersByFt = {
        nix = [
          "deadnix"
          "nix"
        ];
        javascript = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        svelte = [ "eslint_d" ];
        markdown = [ "vale" ];
        gdscript = [ "gdlint" ];
      };
    };
  };
}
