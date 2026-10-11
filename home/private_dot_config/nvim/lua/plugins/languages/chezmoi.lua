local function pick_chezmoi()
  local files = require("chezmoi.commands").list({
    args = { "--path-style", "absolute", "--include", "files", "--exclude", "externals" },
  })
  local items = {}
  for _, file in ipairs(files) do
    table.insert(items, { text = file, file = file })
  end
  Snacks.picker.pick({
    title = "Chezmoi",
    items = items,
    format = "file",
    confirm = function(picker, item)
      picker:close()
      require("chezmoi.commands").edit({ targets = { item.text }, args = { "--watch" } })
    end,
  })
end

return {
  {
    -- highlighting for chezmoi files template files
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
      vim.g["chezmoi#source_dir_path"] = vim.env.HOME .. "/.local/share/chezmoi"
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    cmd = { "ChezmoiEdit" },
    keys = {
      {
        "<leader>sz",
        pick_chezmoi,
        desc = "Chezmoi",
      },
    },
    opts = {
      edit = {
        watch = false,
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
        on_watch = false,
      },
    },
    init = function()
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { vim.env.HOME .. "/.local/share/chezmoi/*" },
        callback = function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  }
}
