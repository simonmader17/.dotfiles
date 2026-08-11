local wiki_path = vim.fn.expand("~/Notes/")
vim.g.vimwiki_list = {
  {
    path = wiki_path,
    syntax = "markdown",
    ext = ".md",
  },
}
vim.g.vimwiki_auto_chdir = 1
vim.g.vimwiki_commentstring = "<!--%s-->"
vim.g.vimwiki_dir_link = "index"
vim.g.vimwiki_global_ext = 0

vim.pack.add({
  "https://github.com/vimwiki/vimwiki",
})

local pick = require("mini.pick")
vim.keymap.set(
  "n",
  "<leader>wf",
  function () pick.builtin.files(nil, { source = { cwd = wiki_path } }) end,
  { desc = "Find wiki files" }
)
vim.keymap.set(
  "n",
  "<leader>ws",
  function () pick.builtin.grep_live(nil, { source = { cwd = wiki_path } }) end,
  { desc = "Grep wiki files" }
)
