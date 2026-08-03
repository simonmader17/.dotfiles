vim.pack.add({
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 24,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
  desc = "Toggle file explorer",
})
vim.keymap.set("n", "<leader>pv", ":NvimTreeFocus<CR>", {
  desc = "Focus file explorer",
})
