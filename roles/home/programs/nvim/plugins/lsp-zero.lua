local zero = require("lsp-zero")
local cmp = require("cmp")
local config = require("lspconfig")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, noremap = true }
	local set = vim.keymap.set

	set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts) -- Diagnostics
	set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts) -- Code Actions
	set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts) -- Rename
	set("n", "<leader>re", function()
		vim.lsp.buf.references()
	end, opts) -- References
end

zero.extend_lspconfig({
	sign_text = true,
	lsp_attach = on_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

zero.setup_servers({
	"eslint",
	"ts_ls",
	"rust_analyzer",
	"pylsp",
	"lua_ls",
	"nil_ls",
	"bashls",
})

config.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				enable = true,
				command = "clippy",
			},
		},
	},
})

cmp.setup({
	sources = {
		{ name = "codeium" },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
		["<S-Tab>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})

zero.on_attach(on_attach)
