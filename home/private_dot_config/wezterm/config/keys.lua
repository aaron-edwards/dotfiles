local M = {}

function M.apply(config, wezterm)
	config.keys = {
		{ key = "\\", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "s", mods = "CTRL|SHIFT", action = wezterm.action({ EmitEvent = "toggle-dark-mode" }) },
	}
	return config
end

return M
