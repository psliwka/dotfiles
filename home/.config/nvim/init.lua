-- Basic settings are kept in a Vim-compatible vimscript file
vim.cmd("source ~/.vimrc")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- Better filetypes support
	"sheerun/vim-polyglot",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "go", "javascript", "vue", "lua", "vimdoc", "cue", "json", "yaml" },
				highlight = {
					enable = true,
				},
			})
		end,
	},
	"psliwka/vim-redact-pass",
	"jjo/vim-cue",

	-- Appearance
	{
		"NTBBloodbath/doom-one.nvim",
		init = function()
			vim.g.doom_one_cursor_coloring = true
			vim.g.doom_one_terminal_colors = true
			vim.g.doom_one_italic_comments = true
			vim.g.doom_one_enable_treesitter = true
			vim.g.doom_one_pumblend_enable = true
			vim.g.doom_one_pumblend_transparency = 10
			vim.g.doom_one_plugin_telescope = true
		end,
		config = function()
			vim.cmd("colorscheme doom-one")
			-- Mute spellchecking suggestions a bit:
			vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true })
			vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true })
			vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true })
			vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true })
			-- Make Treesitter context more prominent
			vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Special" })
			vim.api.nvim_set_hl(0, "TreesitterContextBottom", { undercurl = true, special = "#5b6268" })
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#customizing-how-diagnostics-are-displayed
			for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
				vim.fn.sign_define("DiagnosticSign" .. diag, {
					text = "",
					texthl = "DiagnosticSign" .. diag,
					linehl = "",
					numhl = "DiagnosticSign" .. diag,
				})
			end
		end,
	},
	"nvim-tree/nvim-web-devicons",

	-- LSP integration
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.pyright.setup({})
			lspconfig.gopls.setup({})

			-- Old mappings for reference: TODO: go through them and re-integrate if needed
			-- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
			-- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
			-- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
			-- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
			-- buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
			-- buf_set_keymap('n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
			-- buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<space>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert(),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{
						name = "buffer",
						option = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
					}),
				},
			})
		end,
	},

	-- Additional features
	{
		"echasnovski/mini.nvim",
		branch = "stable",
		config = function()
			require("mini.ai").setup()
			require("mini.align").setup()
			require("mini.bracketed").setup({ comment = { suffix = "" } })
			require("mini.comment").setup()
		end,
	},

	"tpope/vim-fugitive",
	"michaeljsmith/vim-indent-object",
	{
		"machakann/vim-sandwich",
		config = function()
			vim.cmd([[runtime macros/sandwich/keymap/surround.vim]])
		end,
	},
	"tpope/vim-eunuch",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" } },
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						preview_cutoff = 5,
					},
					winblend = 10,
				},
				extensions = {
					undo = {},
				},
			})
			vim.cmd([[
      nnoremap <leader>fd <cmd>Telescope find_files<cr>
      nnoremap <leader>rg <cmd>Telescope live_grep<cr>
      nnoremap <leader>b <cmd>Telescope buffers<cr>
      nnoremap <leader>u <cmd>Telescope undo<cr>
    ]])
		end,
	},
	{
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({})
			vim.cmd([[nnoremap <leader>ft :NvimTreeToggle<CR>]])
		end,
	},
	{
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup({
				options = {
					separator_style = "slant",
				},
			})
		end,
	},

	-- Situational awareness enhancements
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				preview_config = {
					border = "rounded",
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 1000 / 3,
				},
				signs = {
					changedelete = { text = "╹▁" },
				},
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
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = { char = "▏" },
				scope = { char = "▎", highlight = "IblIndent" },
			})
		end,
	},
	"psliwka/vim-smoothie",
	{
		"hoob3rt/lualine.nvim",
		config = function()
			require("lualine").setup({})
		end,
	},
	{
		"unblevable/quick-scope",
		init = function()
			vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, { names = false, rgb_fn = true })
		end,
	},
	{
		"psliwka/vim-dirtytalk",
		build = ":DirtytalkUpdate",
		config = function()
			vim.opt.spelllang = { "en", "programming" }
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({ mode = "topline" })
		end,
	},
})
