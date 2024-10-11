require("gruvbox").setup({
	overrides = {
		SignColumn = { bg = "#282828" },
	},
})

vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
