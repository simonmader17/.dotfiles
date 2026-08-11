--        _             _
--  _ __ | |_   _  __ _(_)_ __  ___
-- | '_ \| | | | |/ _` | | '_ \/ __|
-- | |_) | | |_| | (_| | | | | \__ \
-- | .__/|_|\__,_|\__, |_|_| |_|___/
-- |_|            |___/

require("plugins.nvim-treesitter") -- must go before many other plugins

-- UI
require("plugins.pywal") -- must go before lualine
require("plugins.codestats")
require("plugins.lualine")
require("plugins.nvim-tree")
require("plugins.snacks-nvim")
require("plugins.render-markdown-nvim")

-- completions
require("plugins.mini")
require("plugins.nvim-lspconfig")
require("plugins.lazydev-nvim")
require("plugins.luasnip")
require("plugins.blink-cmp")

-- misc
require("plugins.vimwiki")
require("plugins.img-clip-nvim")
