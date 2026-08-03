--              _   _
--   ___  _ __ | |_(_) ___  _ __  ___
--  / _ \| '_ \| __| |/ _ \| '_ \/ __|
-- | (_) | |_) | |_| | (_) | | | \__ \
--  \___/| .__/ \__|_|\___/|_| |_|___/
--       |_|

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.guicursor = ""
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.updatetime = 1000
vim.opt.winborder = "rounded"

-- tabs and wrapping
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.linebreak = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = false
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.wrap = true

-- window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- show invisible characters
vim.opt.list = true
vim.opt.listchars = "trail:·,tab:→ ,nbsp:␣"

-- deactivate mouse interactivity
vim.opt.mouse = ""

-- persistent undo
vim.opt.undofile = true

-- spelling
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "de_at" }
vim.opt.spelloptions = "noplainbuffer,camel"

-- diagnostics
vim.diagnostic.config({ virtual_text = true })
