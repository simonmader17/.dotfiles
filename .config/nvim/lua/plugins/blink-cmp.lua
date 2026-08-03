vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
})

require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",
    ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
    ["<C-p>"] = { "show", "select_prev", "fallback_to_mappings" },
    ["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = { auto_show = true },
    list = {
      selection = {
        preselect = function ()
          return not require("blink.cmp").snippet_active({ direction = 1 })
        end,
        auto_insert = true,
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
      path = {
        opts = {
          show_hidden_files_by_default = true,
        },
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  snippets = { preset = "luasnip" },
  signature = { enabled = true },
})
