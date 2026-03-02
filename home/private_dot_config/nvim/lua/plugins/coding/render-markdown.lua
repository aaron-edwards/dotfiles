--[[
  Renders markdown formatting inline in the buffer: headings, bold, italic,
  code blocks, tables, checkboxes, and more. Only active for markdown files.
]]
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {},
}