--[[
  Neovim API completion and type annotations for Lua config files.
  Only loads for .lua files, so has no impact on other filetypes.
]]
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}

