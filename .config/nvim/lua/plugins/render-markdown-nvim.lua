vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  file_types = { "markdown", "vimwiki" },
  anti_conceal = {
    enabled = false,
  },
})
