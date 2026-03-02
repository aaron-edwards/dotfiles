--[[
  LSP server installer and manager. :Mason opens the UI to browse,
  install, and update language servers, linters, and formatters.
]]
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",     -- Lua
        "pyright",    -- Python
        "ts_ls",      -- TypeScript / JavaScript
      },
    },
  },
}
