--  _
-- | |___ _ __
-- | / __| '_ \
-- | \__ \ |_) |
-- |_|___/ .__/
--       |_|

vim.lsp.enable({
  "basedpyright",
  "bashls", -- bash-language-server
  "clangd",
  "gopls",
  "jdtls",
  "lua_ls", -- lua-language-server
  "qmlls",
  "rust_analyzer",
  "texlab",
  "tinymist",
  "ts_ls", -- typescript-language-server
  "yamlls", -- yaml-language-server
})

vim.lsp.config("qmlls", {
  cmd = { "qmlls", "-E" },
})

vim.lsp.config("texlab", {
  capabilities = { workspace = { configuration = false } },
  settings = {
    texlab = {
      chktex = {
        onEdit = true,
        onOpenAndSave = true,
      },
    },
  },
})

local group = vim.api.nvim_create_augroup("my_lsp_autocmds", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Set up LSP keymaps",
  group = group,
  callback = function (args)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {
      desc = "Rename symbol",
      buffer = args.buf,
    })
    vim.keymap.set("n", "<F3>", vim.lsp.buf.format, {
      desc = "Format current file",
      buffer = args.buf,
    })
  end,
})
