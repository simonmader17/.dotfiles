vim.pack.add({
  "https://github.com/nvim-mini/mini.notify",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.pick",
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
local sel = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { bg = sel.bg })
