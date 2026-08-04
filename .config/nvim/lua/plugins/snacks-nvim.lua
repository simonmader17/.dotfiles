vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
  image = {
    enabled = true,
    doc = {
      inline = false,
      float = true,
      max_width = 80,
      max_height = 40,
    },
    bo = {
      buftype = "nofile",
      bufhidden = "wipe",
      swapfile = false,
      modifiable = false,
    },
  },
})
