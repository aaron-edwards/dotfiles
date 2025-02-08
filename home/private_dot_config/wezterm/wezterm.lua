local wezterm = require("wezterm")

local globals = {
	font_size = 14,

	default_scheme = "light",
	dark_scheme = "dark",
	light_scheme = "light",

  is_darwn = wezterm.target_triple:find("darwin") ~= nil,
}

local function fold(table, op, init)
	local ret = init
	for _, v in pairs(table) do
		ret = op(ret, v)
	end
	return ret
end

local config = fold({
	"config/appearance",
	"config/keys",
}, function(acc, lib)
	return require(lib).apply(acc, wezterm, globals)
end, wezterm.config_builder())

require("lib/actions").register(config, wezterm, globals)

return config
