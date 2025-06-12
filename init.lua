-- Include require statements for your different configurations
require("plugins")
require("keys")
require("opts")
require("dap-config")
require("claude-code-config")
-- require("avante-config")

-- Mason Setup
require("mason").setup({
	ui = {
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"angularls",
		"astro",
		"cssls",
		"html",
		"jsonls",
		"pyright",
		"ts_ls",
		"vimls",
		"lua_ls",
		"rust_analyzer",
		"gopls",
	},
})

-- LSP Setup
local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({
	capabilities = lsp_capabilities,
})

lspconfig.gopls.setup({
	capabilities = lsp_capabilities,
})

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").jsonls.setup({
	capabilities = capabilities,
})

local pyright_opts = {
	single_file_support = true,
	settings = {
		pyright = {
			disableLanguageServices = false,
			disableOrganizeImports = false,
		},
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "basic",
				useLibraryCodeForTypes = true,
			},
		},
	},
}

lspconfig.pyright.setup({
	capabilities = lsp_capabilities,
	pyright_opts,
})

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

lspconfig.ts_ls.setup({
	capabilities = lsp_capabilities,
	init_options = {
		preferences = {
			importModuleSpecifierPreference = "relative",
		},
	},
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
})

require("lspconfig").html.setup({
	capabilities = capabilities,
})

lspconfig.astro.setup({
	capabilities = lsp_capabilities,
})

lspconfig.angularls.setup({
	capabilities = lsp_capabilities,
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

-- Linting Setup
local lint = require("lint")
lint.linters_by_ft = {
	python = { "black" },
	javascript = { "eslint" },
	typescript = { "eslint" },
	rust = { "cargo" },
	toml = { "cargo" },
}

require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier" },
		typescript = { "prettierd", "prettier" },
		rust = { "rustfmt" },
		xml = { "xmllint", "prettierd", "prettier" },
	},
})

-- Theme
vim.cmd("colorscheme rose-pine")

-- LSP Diagnostics Options Setup
local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

sign({ name = "DiagnosticSignError", text = "" })
sign({ name = "DiagnosticSignWarn", text = "" })
sign({ name = "DiagnosticSignHint", text = "" })
sign({ name = "DiagnosticSignInfo", text = "" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Treesitter Plugin Setup
require("nvim-treesitter.configs").setup({
	ensure_installed = { "html", "css", "lua", "json", "python", "javascript", "typescript", "rust", "toml" },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	ident = { enable = true },
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
})

-- Rust Plugin Setup
local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<M-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
	dap = {
		adapter = false,
	},
})

-- Completion Plugin Setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp", keyword_length = 3 },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lua", keyword_length = 2 },
		{ name = "buffer", keyword_length = 2 },
		{ name = "vsnip", keyword_length = 2 },
		{ name = "calc" },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "λ",
				vsnip = "⋗",
				buffer = "Ω",
				path = "🖫",
			}
			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
})

-- Statusline Setup
require("lualine").setup({
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
		},
	},
})

-- Fugitive shortcuts
vim.api.nvim_set_keymap("n", "<leader>gs", ":G<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gw", ":Gwrite<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gl", ":Git pull<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", { noremap = true, silent = true })

-- Diffview shortcuts
vim.api.nvim_set_keymap("n", "<leader>do", ":DiffviewOpen<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dc", ":DiffviewClose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dh", ":DiffviewFileHistory<CR>", { noremap = true, silent = true })

-- Gitsigns Setup
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>hS", gs.stage_buffer)
		map("n", "<leader>hu", gs.undo_stage_hunk)
		map("n", "<leader>hR", gs.reset_buffer)
		map("n", "<leader>hp", gs.preview_hunk)
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>tb", gs.toggle_current_line_blame)
		map("n", "<leader>hd", gs.diffthis)
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end)
		map("n", "<leader>td", gs.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})

-- Set highlights
vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "DiffDelete" })

-- Options setup
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.cmd([[
   set signcolumn=yes
   autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- vim.g.vimspector_enable_mappings = "HUMAN"

-- Autoread when files change externally
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

vim.opt.termguicolors = true
require("bufferline").setup({})

require("trouble").setup({})

require("zen-mode").setup({
	window = {
		width = 0.8,
		height = 0.8,
	},
})
