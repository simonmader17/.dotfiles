--  _
-- | | _____ _   _ _ __ ___   __ _ _ __  ___
-- | |/ / _ \ | | | '_ ` _ \ / _` | '_ \/ __|
-- |   <  __/ |_| | | | | | | (_| | |_) \__ \
-- |_|\_\___|\__, |_| |_| |_|\__,_| .__/|___/
--           |___/                |_|

local k = vim.keymap.set

-- system clipboard
k({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
k("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
k({ "n", "x" }, "<leader>d", '"+d', { desc = "Cut to system clipboard" })
k("n", "<leader>D", '"+D', { desc = "Cut to end of line to system clipboard" })
k({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
k({ "n", "x" }, "<leader>P", '"+P', {
  desc = "Paste before from system clipboard",
})

-- diagnostics
k("n", "gl", vim.diagnostic.open_float, {
  desc = "Show diagnostics in floating window",
})

-- search highlight
k("n", "<Esc>", ":nohlsearch<CR>", {
  desc = "Clear search highlight",
  silent = true,
})

-- split window
k("n", '<leader>"', ":new<CR>", { desc = "Split window horizontally" })
k("n", "<leader>%", ":vnew<CR>", { desc = "Split window vertically" })

-- keep cursor in the middle of the screen when scrolling up/down
k("n", "<C-d>", "<C-d>zz", {
  desc = "Scroll half page down, keep cursor centered",
})
k("n", "<C-u>", "<C-u>zz", {
  desc = "Scroll half page up, keep cursor centered",
})

-- keep search terms in the middle of the screen
k("n", "n", "nzzzv", { desc = "Next search match, centered" })
k("n", "N", "Nzzzv", { desc = "Previous search match, centered" })

-- window navigation
k("n", "<C-h>", "<C-w>h", { desc = "Go to window on the left" })
k("n", "<C-j>", "<C-w>j", { desc = "Go to window below" })
k("n", "<C-k>", "<C-w>k", { desc = "Go to window above" })
k("n", "<C-l>", "<C-w>l", { desc = "Go to window on the right" })

-- window movement
k("n", "<M-H>", "<C-w>H", { desc = "Move window to the left" })
k("n", "<M-J>", "<C-w>J", { desc = "Move window to the bottom" })
k("n", "<M-K>", "<C-w>K", { desc = "Move window to the top" })
k("n", "<M-L>", "<C-w>L", { desc = "Move window to the right" })

-- window resizing
k("n", "<M-h>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
k("n", "<M-j>", ":resize -2<CR>", { desc = "Decrease window height" })
k("n", "<M-k>", ":resize +2<CR>", { desc = "Increase window height" })
k("n", "<M-l>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- move multiple lines
k("x", "<C-j>", ":m '>+1<CR>gv=gv", {
  desc = "Move selected lines down and reindent",
})
k("x", "<C-k>", ":m '<-2<CR>gv=gv", {
  desc = "Move selected lines up and reindent",
})

-- my format/compile/open scripts
k("n", "<leader>c", ":update<CR>:!~/scripts/compile.sh %:p:S<CR>", {
  desc = "Save and compile current file",
})
k("n", "<leader>a", ":!~/scripts/autocompile.sh %:p:S &<CR><CR>", {
  desc = "Toggle autocompile watcher",
})
k("n", "<leader>f", ":update<CR>:!~/scripts/format.sh %:p:S<CR><CR>", {
  desc = "Save and format current file",
})
k("n", "<leader>o", ":!~/scripts/open.sh %:p:S<CR><CR>", {
  desc = "Open current file's output/preview",
})
