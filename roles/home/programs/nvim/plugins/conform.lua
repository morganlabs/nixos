local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		html = { "htmlbeautifier" },
		bash = { "beautysh" },
		rust = { "rustfmt" },
		yaml = { "yamlfix" },
		nix = { "nixfmt" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

vim.defer_fn(function()
	vim.keymap.set({ "n", "v" }, "<leader>fmt", function()
		conform.format({
			async = false,
			lsp_fallback = true,
			timeout_ms = 500,
		})
	end, { desc = "Format file or range (in visual mode)" })
end, 0)
