local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

require("harpoon").setup()

-- Need this, no clue why, but it works so idrc
vim.defer_fn(function()
	vim.keymap.set("n", "<leader>a", function()
		mark.add_file()
		print("File marked")
	end)
end, 0)

vim.keymap.set("n", "<C-y>", function()
	ui.toggle_quick_menu()
end)

vim.keymap.set("n", "<C-h>", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<C-j>", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<C-k>", function()
	ui.nav_file(3)
end)
vim.keymap.set("n", "<C-l>", function()
	ui.nav_file(4)
end)
