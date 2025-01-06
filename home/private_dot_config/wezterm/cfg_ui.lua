local globals = require("globals")
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = globals.font_size
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.show_new_tab_button_in_tab_bar = true
config.enable_wayland = true
config.use_fancy_tab_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  font_size = globals.font_size,
}

return config
