--[[
  Language server configuration using the native vim.lsp API (Neovim 0.11+).
  nvim-lspconfig registers default cmd/filetypes/root_dir for known servers.
  We override settings where needed, then enable the servers explicitly.
]]
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "williamboman/mason-lspconfig.nvim", "folke/lazydev.nvim" },
	config = function()
		-- Keymaps applied whenever an LSP attaches to a buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = args.buf, desc = desc })
				end
				map("gd", vim.lsp.buf.definition, "Go to definition")
				map("gD", vim.lsp.buf.declaration, "Go to declaration")
				map("gr", vim.lsp.buf.references, "References")
				map("K", vim.lsp.buf.hover, "Hover docs")
				map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
				map("<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
			end,
		})

		-- Override lua_ls defaults with Neovim-specific settings
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim", "Snacks" } },
					workspace = { checkThirdParty = false },
				},
			},
		})

		-- Enable servers (nvim-lspconfig provides default configs for each)
		vim.lsp.enable({ "lua_ls", "pyright", "ts_ls" })
	end,
}
