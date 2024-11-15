{
  pkgs,
  nixvim,
  config,
  ...
}:
{
  home.packages = with pkgs; [ luajitPackages.jsregexp ];

  programs.nixvim.plugins.lazy.plugins = [
    {
      name = "luasnip";
      pkg = pkgs.vimPlugins.luasnip;

      opts = { };

      config = ''
        function(_, opts)
          local ls = require("luasnip")
          ls.setup(opts)

          -- TODO Actually use Luasnip...
          -- vim.keymap.set({"i"}, "<C-K>", ls.expand, {silent = true})
          -- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
          -- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
          -- vim.keymap.set({"i", "s"}, "<C-E>", function()
          -- 	if ls.choice_active() then
          -- 		ls.change_choice(1)
          -- 	end
          -- end, {silent = true})
        end
      '';
    }
  ];
}
