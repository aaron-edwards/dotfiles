--[[
  Test runner. Runs tests inline with results shown in the buffer.
  Adapters: pytest (Python), jest (JS/TS). Replace neotest-jest with
  neotest-vitest if your project uses Vitest.
]]
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end,                       desc = "Run nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,     desc = "Run file" },
    { "<leader>tl", function() require("neotest").run.run_last() end,                  desc = "Run last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end,                desc = "Summary" },
    { "<leader>to", function() require("neotest").output_panel.toggle() end,           desc = "Output panel" },
  },
  opts = function()
    return {
      adapters = {
        require("neotest-python"),
        require("neotest-jest"),
      },
    }
  end,
}