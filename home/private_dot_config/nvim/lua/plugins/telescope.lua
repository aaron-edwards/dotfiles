local builtin = require("telescope.builtin")

return {
	{
		"nvim-telescope/telescope.nvim", 
		tag = '0.1.8',
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>/", builtin.live_grep, desc = "Grep (Root Dir)" },
			{ "<leader>ff", builtin.find_files, desc = "Find Files (Root Dir)" },
		},
	},
}
