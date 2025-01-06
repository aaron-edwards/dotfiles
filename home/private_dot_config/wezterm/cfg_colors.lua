local wezterm = require('wezterm')
local globals = require('globals')

local extra_colors = {
  [globals.light_scheme] = {
    bg_0 = "#fbf3db",
    bg_1 = '#ece3cc',
    bg_2 = '#d5cdb6',
    dim_0 = '#909995',
    fg_0 = '#53676d',
    fg_1 = '#3a4d53',
  },
  [globals.dark_scheme] = {
    bg_0 = "#103c48",
    bg_1 = '#184956',
    bg_2 = '#2d5b69',
    dim_0 = '#72898f',
    fg_0 = '#adbcbc',
    fg_1 = '#cad8d9',
  },
}

--- Patch the color schemes with personal settings
local function patch_colors(colors, light)
  local green = table.pack(wezterm.color.parse(colors.ansi[3]):hsla())
  colors.selection_bg = wezterm.color.from_hsla(green[1], green[2], green[3], 0.33)
  return colors
end


local function sync_bar(cfg, colors)
  local extra = extra_colors[cfg.color_scheme] or {}
  cfg.colors = cfg.colors or {}
  cfg.colors.tab_bar = {
    active_tab = {
      bg_color = colors.background,
      fg_color = colors.foreground,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = extra.bg_1,
      fg_color = colors.foreground,
      intensity = 'Normal',
    },
    inactive_tab_hover = {
      bg_color = extra.bg_1,
      fg_color = colors.foreground,
      intensity = "Bold",
    },
    new_tab = {
      bg_color = extra.bg_1,
      fg_color = colors.foreground,
      intensity = 'Bold',
    },
    new_tab_hover = {
      bg_color = colors.background,
      fg_color = colors.foreground,
      intensity = 'Bold',
    }
  }

  cfg.window_frame = {
    active_titlebar_bg = extra_colors[cfg.color_scheme].bg_2,
  }
  return cfg
end


local config = wezterm.config_builder()

local all_schemes = wezterm.get_builtin_color_schemes()
config.color_schemes = {
  [globals.light_scheme] = patch_colors(all_schemes[globals.light_scheme]),
  [globals.dark_scheme] = patch_colors(all_schemes[globals.dark_scheme]),
}
config.color_scheme = globals.default_light
    and globals.light_scheme
    or globals.dark_scheme

config = sync_bar(config, config.color_schemes[config.color_scheme])

wezterm.on("toggle-dark-mode", function(window, _pane)
  local overrides = window:get_config_overrides() or {}

  overrides.color_scheme = overrides.color_scheme == globals.light_scheme
      and globals.dark_scheme
      or globals.light_scheme

  overrides = sync_bar(overrides, config.color_schemes[overrides.color_scheme])

  window:set_config_overrides(overrides)
end)

return config
