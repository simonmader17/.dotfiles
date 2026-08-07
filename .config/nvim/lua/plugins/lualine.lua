vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.opt.showmode = false
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "pywal-nvim",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename", "branch", "diff", "diagnostics" },
    lualine_c = {},
    -- lualine_x = { "encoding", "fileformat", "filetype", "%{CodeStatsXp()}" },
    lualine_x = {
      "encoding",
      "fileformat",
      {
        function ()
          local buf = vim.api.nvim_get_current_buf()
          local hl = vim.treesitter.highlighter.active[buf]
          if not hl then
            return ""
          end
          return " " .. hl.tree:lang()
        end,
      },
      "lsp_status",
      "filetype",
      {
        function ()
          if vim.fn.exists("*CodeStatsXp") == 1 then
            return vim.fn.CodeStatsXp()
          end
          return ""
        end,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "nvim-tree" },
})
