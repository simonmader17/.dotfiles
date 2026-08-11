vim.pack.add({
  "https://github.com/hakonharnes/img-clip.nvim",
})

require("img-clip").setup({})

vim.keymap.set("n", "<leader>pi", "<cmd>PasteImage<CR>", {
  desc = "Paste image from system clipboard",
})
