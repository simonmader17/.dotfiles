vim.pack.add({
  "https://github.com/nvim-mini/mini.notify",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/nvim-mini/mini.surround",
})

require("mini.notify").setup()
require("mini.pairs").setup()

require("mini.pick").setup()
vim.keymap.set("n", "<leader>pf", ":Pick files<CR>", {
  desc = "Find files",
})
vim.keymap.set("n", "<leader>ph", ":Pick help<CR>", {
  desc = "Search help tags",
})
vim.keymap.set("n", "<leader>ps", ":Pick grep_live<CR>", {
  desc = "Grep files",
})
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "PmenuSel" })

require("mini.surround").setup()
