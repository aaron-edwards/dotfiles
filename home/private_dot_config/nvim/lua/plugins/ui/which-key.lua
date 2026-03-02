--[[
  Displays a popup of available keybindings when pausing mid-chord.
  Also defines group labels for key prefixes (find, git, hunks, AI, toggles).
]]
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>h", group = "hunks" },
			{ "<leader>a", group = "AI" },
			{ "<leader>c", group = "code" },
			{ "<leader>t", group = "toggles" },
		})
	end,
}

