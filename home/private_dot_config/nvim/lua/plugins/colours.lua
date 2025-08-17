return {
	-- {
		--  'sainnhe/everforest',
		--  lazy = false,
		--  priority = 1000,
		--  config = function()
			--    -- Optionally configure and load the colorscheme
			--    -- directly inside the plugin declaration.
			--    vim.g.everforest_enable_italic = true
			--    vim.cmd.colorscheme('everforest')
			--  end
			-- },
			{
				"neanias/everforest-nvim",
				version = false,
				lazy = false,
				priority = 1000, -- make sure to load this before all the other start plugins
				-- Optional; default configuration will be used if setup isn't called.
				config = function()
					require("everforest").setup({
						-- Your config here
					})
					require("everforest").load()
				end,
			}
		}
