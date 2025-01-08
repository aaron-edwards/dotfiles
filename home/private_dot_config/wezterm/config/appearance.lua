local colours = require("lib/colours")

local M = {}

function M.apply(config, wezterm, globals)
	config.font_size = globals.font_size

	config.show_new_tab_button_in_tab_bar = true
	config.enable_wayland = true
	config.use_fancy_tab_bar = true
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

	config.window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}

	config.color_schemes = {
		[globals.light_scheme] = colours.light,
		[globals.dark_scheme] = colours.dark,
	}
	config.color_scheme = globals.default_scheme

	config.colors, config.window_frame = colours.apply_to_bar(config, globals.default_scheme)

	return config
end

return M
