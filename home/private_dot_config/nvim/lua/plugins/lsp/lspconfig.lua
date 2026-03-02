--[[
  Language server client configuration. Attaches keymaps for navigation,
  hover docs, rename, code actions, and diagnostics on LspAttach.
]]
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "williamboman/mason-lspconfig.nvim", "folke/lazydev.nvim" },
  config = function()
    -- Keymaps applied whenever an LSP attaches to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = args.buf, desc = desc })
        end
        map("gd",         vim.lsp.buf.definition,    "Go to definition")
        map("gD",         vim.lsp.buf.declaration,   "Go to declaration")
        map("gr",         vim.lsp.buf.references,    "References")
        map("K",          vim.lsp.buf.hover,         "Hover docs")
        map("<leader>cr", vim.lsp.buf.rename,        "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action,   "Code action")
        map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
      end,
    })

    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = { globals = { "vim", "Snacks" } },
          workspace = { checkThirdParty = false },
        },
      },
    })
    lspconfig.pyright.setup({})
    lspconfig.ts_ls.setup({})

  end,
}