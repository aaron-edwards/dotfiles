--[[
  Magit-style git interface. Full staging, committing, branching, rebasing
  and more in a native Neovim UI. Complements lazygit (<leader>gg) for
  quick operations vs neogit (<leader>gN) for detailed workflow.
]]
return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
  opts = {},
}