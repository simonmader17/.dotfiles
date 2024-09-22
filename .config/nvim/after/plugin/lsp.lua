local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		lsp_zero.default_setup,
	},
})

require('lspconfig').jdtls.setup({
	config = {
		settings = {
			java = {
				signatureHelp = {
					enabled = true
				}
			}
		}
	}
})

-- lua language server
local lua_opts = lsp_zero.nvim_lua_ls({
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
})
require('lspconfig').lua_ls.setup(lua_opts)
