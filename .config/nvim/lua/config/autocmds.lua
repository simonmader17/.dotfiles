--              _                           _
--   __ _ _   _| |_ ___   ___ _ __ ___   __| |___
--  / _` | | | | __/ _ \ / __| '_ ` _ \ / _` / __|
-- | (_| | |_| | || (_) | (__| | | | | | (_| \__ \
--  \__,_|\__,_|\__\___/ \___|_| |_| |_|\__,_|___/

local group = vim.api.nvim_create_augroup("my_autocmds", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Hide the sign column and cursorline in man pages",
  group = group,
  pattern = "man",
  callback = function ()
    vim.opt_local.cursorline = false
    vim.opt_local.signcolumn = "no"
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  desc = "Color trailing whitespaces",
  group = group,
  callback = function ()
    if vim.w.trailing_ws_match then
      return
    end
    vim.w.trailing_ws_match = vim.fn.matchadd("DiffDelete", [[\s\+$]])
  end,
})
