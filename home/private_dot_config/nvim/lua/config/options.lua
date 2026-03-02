local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                       -- Enable mouse support
-- opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard
opt.swapfile = false                  -- Don't use swapfile
opt.undofile = true                   -- Persistent undo across sessions

g.mapleader = " "
g.maplocalleader = "\\"

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true           -- Show line number
opt.relativenumber = true   -- Relative line numbers
opt.showmatch = true        -- Highlight matching parenthesis
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.signcolumn = "yes"      -- Always show sign column (no layout shift)
opt.scrolloff = 8           -- Keep 8 lines above/below cursor
opt.splitright = true       -- Vertical splits open to the right
opt.splitbelow = true       -- Horizontal splits open below

-----------------------------------------------------------
-- Search
-----------------------------------------------------------
opt.ignorecase = true       -- Case-insensitive search...
opt.smartcase = true        -- ...unless uppercase is typed

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Shift 2 spaces when tab
opt.tabstop = 2             -- 1 tab == 2 spaces
opt.smartindent = true      -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.history = 1000          -- Remember N lines in history
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 250        -- ms to wait for trigger an event

