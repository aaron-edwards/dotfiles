--[[
  Add, delete, and replace surrounding brackets/quotes/tags.
  Default mappings use `s` as prefix (replaces the rarely-used `s` substitute key):
    sa{motion}{char}  add surrounding    e.g. saiw" wraps word in quotes
    sd{char}          delete surrounding e.g. sd"
    sr{old}{new}      replace surrounding e.g. sr"'
]]
return {
  "echasnovski/mini.surround",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}