local wezterm = require("wezterm")

local M = {}

local indexed = {
	[232] = "#000000",
	[233] = "#002430",
	[234] = "#103c48", -- Dark bg_0,
	[235] = "#184956", -- Dark bg_1,
	[236] = "#2d5b69", -- Dark bg_2,
	[237] = "#39616e",
	[238] = "#446974",
	[239] = "#50717b",
	[240] = "#5b7881",
	[241] = "#668088",
	[242] = "#72898f", -- Dark dim_0,
	[243] = "#7c8d90",
	[244] = "#869392",
	[245] = "#909995", -- Light dim_0,
	[246] = "#9ba099",
	[247] = "#a6a99f",
	[248] = "#b2b2a4",
	[249] = "#bdbaaa",
	[250] = "#c8c3af",
	[251] = "#dcd1b6", -- Light bg_2,
	[252] = "#ece3cc", -- Light bg_1,
	[253] = "#fbf3db", -- Light bg_0,
	[254] = "#fff9e0",
	[255] = "#ffffff",
}

M.pallete = {
	light = {
		bg_00 = "#fff9e0",
		bg_0 = "#fbf3db",
		bg_1 = "#ece3cc",
		bg_2 = "#dcd1b6",
		dim_0 = "#909995",
		fg_0 = "#53676d",
		fg_1 = "#3a4d53",

		red = "#d2212d",
		green = "#489100",
		yellow = "#ad8900",
		blue = "#0072d4",
		magenta = "#ca4898",
		cyan = "#009c8f",
		orange = "#c25d1e",
		violet = "#8762c6",

		br_red = "#cc1729",
		br_green = "#428b00",
		br_yellow = "#a78300",
		br_blue = "#006dce",
		br_magenta = "#c44392",
		br_cyan = "#00978a",
		br_orange = "#bc5819",
		br_violet = "#825dc0",

		bar = {
			bg = "#dcd1b6",
			inactive = "#ece3cc",
			hover = "#ece3cc",
		},
	},
	dark = {
		bg_00 = "#002430",
		bg_0 = "#103c48",
		bg_1 = "#184956",
		bg_2 = "#2d5b69",
		dim_0 = "#72898f",
		fg_0 = "#adbcbc",
		fg_1 = "#cad8d9",

		red = "#fa5750",
		green = "#75b938",
		yellow = "#dbb32d",
		blue = "#4695f7",
		magenta = "#f275be",
		cyan = "#41c7b9",
		orange = "#ed8649",
		violet = "#af88eb",

		br_red = "#ff665c",
		br_green = "#84c747",
		br_yellow = "#ebc13d",
		br_blue = "#58a3ff",
		br_magenta = "#ff84cd",
		br_cyan = "#53d6c7",
		br_orange = "#fd9456",
		br_violet = "#bd96fa",

		bar = {
			bg = "#002430",
			inactive = "#082f3b",
			hover = "#082f3b",
		},
	},
}

local function generate(pallete)
	return {
		background = pallete.bg_0,
		foreground = pallete.fg_0,

		cursor_bg = pallete.fg_0,
		cursor_border = pallete.fg_0,
		cursor_fg = pallete.bg_0,

		selection_bg = string.sub(pallete.br_green, 2) .. "33",

		split = pallete.br_cyan,

		tab_bar = {
			background = pallete.bar.bg,
			active_tab = {
				bg_color = pallete.bg_0,
				fg_color = pallete.fg_0,
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = pallete.bar.inactive,
				fg_color = pallete.fg_0,
			},
			inactive_tab_hover = {
				bg_color = pallete.bar.hover,
				fg_color = pallete.fg_0,
			},
			new_tab = {
				bg_color = pallete.bar.inactive,
				fg_color = pallete.fg_0,
			},
			new_tab_hover = {
				bg_color = pallete.bar.hover,
				fg_color = pallete.fg_0,
			},
		},

		ansi = {
			pallete.bg_0,
			pallete.red,
			pallete.green,
			pallete.yellow,
			pallete.blue,
			pallete.magenta,
			pallete.cyan,
			pallete.fg_0,
		},
		brights = {
			pallete.bg_1,
			pallete.br_red,
			pallete.br_green,
			pallete.br_yellow,
			pallete.br_blue,
			pallete.br_magenta,
			pallete.br_cyan,
			pallete.fg_1,
		},
		indexed = indexed,
	}
end

M.light = generate(M.pallete.light)
M.dark = generate(M.pallete.dark)

function M.apply_to_bar(config, scheme)
	local tab_bar = config.color_schemes[scheme].tab_bar
	local window_frame = config.window_frame or {}

	window_frame.active_titlebar_bg = tab_bar.background
	window_frame.inactive_titlebar_bg = tab_bar.background

	return { tab_bar = tab_bar }, window_frame
end

return M
