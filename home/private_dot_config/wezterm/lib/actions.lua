local colours = require("lib/colours")

local M = {}

function M.register(config, wezterm, globals)
	wezterm.on("toggle-dark-mode", function(window, _pane)
		local overrides = window:get_config_overrides() or {}

		overrides.color_scheme = overrides.color_scheme == globals.light_scheme and globals.dark_scheme
			or globals.light_scheme

		overrides.colors, overrides.window_frame = colours.apply_to_bar(config, overrides.color_scheme)

		window:set_config_overrides(overrides)
	end)
end

return M
