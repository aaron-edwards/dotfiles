local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.keys = {
  { key = '\\', mods = 'CTRL', action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = '-',  mods = 'CTRL', action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = 't',  mods = 'CTRL', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },
  { key = 'w',  mods = 'CTRL', action = wezterm.action { CloseCurrentTab = { confirm = false } } },
  { key = 'l',  mods = 'CTRL', action = wezterm.action { EmitEvent = 'toggle-dark-mode' } },
}

return config
