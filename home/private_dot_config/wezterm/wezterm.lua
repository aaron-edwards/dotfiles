local utils = require("utils")

return utils.merge_all(
  require("cfg_ui"),
  require("cfg_colors"),
  require("cfg_keys"),
  {}
)
