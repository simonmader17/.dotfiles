-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- telescope file search
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	-- treesitter syntax highlighting
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

	-- lsp-zero language server
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			--- Uncomment these if you want to manage LSP servers from neovim
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{
				'L3MON4D3/LuaSnip',
				requires = { "rafamadriz/friendly-snippets" },
			},
		}
	}
	-- more completions
	use 'hrsh7th/cmp-nvim-lsp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'https://github.com/FelipeLema/cmp-async-path'

	-- auto closing of parenthesis etc.
	use 'raimondi/delimitmate'

	-- auto closing of html tags
	use 'windwp/nvim-ts-autotag'

	-- Code::Stats
	use 'https://gitlab.com/code-stats/code-stats-vim.git'

	-- lualine.nvim
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons' }
	}

	-- nvim-tree
	use 'nvim-tree/nvim-tree.lua'

	-- pywal.nvim
	-- use {
	-- 	'AlphaTechnolog/pywal.nvim',
	-- 	as = 'pywal'
	-- }
	use {
		"https://github.com/simonmader17/pywal.nvim",
		as = "pywal"
	}

	-- when nothing seems to work
	use 'eandrju/cellular-automaton.nvim'

	-- Comment.nvim
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	-- dashboard
	use {
		'goolord/alpha-nvim',
		requires = { 'nvim-tree/nvim-web-devicons' }
	}

	-- color previewer
	use "brenoprata10/nvim-highlight-colors"

	-- vimtex
	use "lervag/vimtex"

	-- latex math symbols
	use "amarakon/nvim-cmp-lua-latex-symbols"

	-- nvim-markdown
	use "ixru/nvim-markdown"

	-- Vim Tmux Navigator
	use "christoomey/vim-tmux-navigator"
end)
