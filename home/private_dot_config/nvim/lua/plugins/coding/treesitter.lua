--[[
  Syntax highlighting using tree-sitter grammars.
  Parsers: lua, vim, vimdoc, bash, python, typescript, tsx, javascript, go.
]]
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "lua", "vim", "vimdoc", "bash",
      "python",
      "typescript", "tsx", "javascript",
      "go",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}