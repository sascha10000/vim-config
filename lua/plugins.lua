-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")

	use("simrat39/rust-tools.nvim")

	-- Debugging
	use("nvim-lua/plenary.nvim")
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
	use("leoluz/nvim-dap-go")

	use("nvim-treesitter/nvim-treesitter")
	-- use("puremourning/vimspector")

	-- Really needed?
	use("voldikss/vim-floaterm")

	-- Completion framework:
	use("hrsh7th/nvim-cmp")

	-- LSP completion source:
	use("hrsh7th/cmp-nvim-lsp")

	-- Useful completion sources:
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/vim-vsnip")

	-- Fuzzy Search
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Theme
	use({ "rose-pine/neovim", as = "rose-pine" })

	-- undotree
	use("mbbill/undotree")

	-- Linting
	use("mfussenegger/nvim-lint")

	-- Statusline
	use({
		"nvim-lualine/lualine.nvim",
	})

	use("nvim-tree/nvim-web-devicons")

	-- Gitsigns
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- Conform
	use("stevearc/conform.nvim")

	-- Fugitive
	use("tpope/vim-fugitive")

	-- Git Diffview
	use("sindrets/diffview.nvim")

	-- angular templates
	use({ "joeveiga/ng.nvim" })

	use({ "folke/trouble.nvim" })

	use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })

	use("folke/zen-mode.nvim")
	-- Extension for search (highlights all matches)
	use({ "kevinhwang91/nvim-hlslens" })
end)
