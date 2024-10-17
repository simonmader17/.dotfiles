-- ██████╗ ███████╗███╗   ███╗ █████╗ ██████╗ 
-- ██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔══██╗
-- ██████╔╝█████╗  ██╔████╔██║███████║██████╔╝
-- ██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══██║██╔═══╝ 
-- ██║  ██║███████╗██║ ╚═╝ ██║██║  ██║██║     
-- ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     

---- <leader> mappings ---------------------------------------------------------

-- nvim-tree
vim.keymap.set("n", "<leader>pv", ":NvimTreeFocus<CR>")
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- (auto)compile, format and open document
vim.keymap.set("n", "<leader>c", ":w<CR>:!~/scripts/compile.sh \"%:p\"<CR>", { noremap = true })
vim.keymap.set("n", "<leader>a", ":call jobstart([expand('~/scripts/autocompile.sh'), expand('%:p')])<CR>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":w<CR>:!~/scripts/format.sh \"%:p\"<CR><CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>o", ":!~/scripts/open.sh \"%:p\"<CR><CR>", { noremap = true, silent = true })

-- when nothing works anymore...
vim.keymap.set("n", "<leader>fml", function()
	vim.cmd("CellularAutomaton make_it_rain")
	vim.opt.wrap = false
end)
vim.keymap.set("n", "<leader>gol", function()
	vim.cmd("CellularAutomaton game_of_life")
	vim.opt.wrap = false
end)

---- other mappings ------------------------------------------------------------

-- spell checking
vim.keymap.set("n", "<F8>", ":set spell! spelllang=de_at<CR>")
vim.keymap.set("i", "<F8>", ":set spell! spelllang=de_at<CR>")

vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O")

-- move multiple lines
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv") -- "x" mode is visual mode without select mode
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
