--[[
  Tab bar showing open buffers with LSP diagnostic indicators.
  <S-h> / <S-l> to cycle, [b / ]b as alternatives.
]]
return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[b",    "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b",    "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
    },
  },
}