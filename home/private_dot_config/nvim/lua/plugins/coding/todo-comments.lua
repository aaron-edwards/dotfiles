--[[
  Highlights TODO, FIXME, HACK, NOTE, WARN etc. in comments.
  <leader>ft opens a picker showing all todos in the project.
]]
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo Comments" },
  },
}