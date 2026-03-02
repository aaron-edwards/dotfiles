--[[
  Syntax highlighting using tree-sitter grammars.
  Parsers: lua, vim, vimdoc, bash, python, typescript, tsx, javascript.
]]
return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"lua",
			"vim",
			"vimdoc",
			"bash",
			"python",
			"typescript",
			"tsx",
			"javascript",
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}

