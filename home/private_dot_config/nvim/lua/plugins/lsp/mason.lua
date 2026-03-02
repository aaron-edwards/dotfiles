--[[
  LSP server installer and manager. :Mason opens the UI to browse,
  install, and update language servers, linters, and formatters.
  mason-tool-installer handles auto-install for both LSP servers and formatters.
]]
return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		dependencies = { "williamboman/mason.nvim" },
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers
				"lua_ls", -- Lua
				"pyright", -- Python
				"ts_ls", -- TypeScript / JavaScript
				-- Formatters
				"stylua", -- Lua
				"ruff", -- Python
				"prettier", -- JS / TS / JSON / CSS / HTML
			},
		},
	},
}

