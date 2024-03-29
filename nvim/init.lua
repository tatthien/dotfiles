---------------
--  PLUGINS  --
---------------
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
	-- Lsp manager
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{

		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
		end,
	},

	-- Display a popup with possible keybindings of the command you started typing
	-- Sorry to my bad memory
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	-- colorscheme
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
			})
			vim.cmd([[colorscheme gruvbox]])
		end,
	},

	-- Indent line
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup()
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"toml",
					"fish",
					"php",
					"json",
					"yaml",
					"html",
					"css",
					"scss",
					"javascript",
					"typescript",
					"go",
					"gomod",
					"vue",
					"hcl",
					"markdown",
					"markdown_inline",
					"vimdoc",
					"vim",
					"bash",
					"lua",
					"yaml",
					"tsx",
					"bash",
				},
				highlight = {
					enable = true,
					-- Disable slow treesitter highlight for large files
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = true,
				},
				indent = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				autopairs = {
					enable = true,
				},
				auto_install = true,
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup()
		end,
	},

	-- Lsp
	{
		"glepnir/lspsaga.nvim",
		config = function()
			local status, saga = pcall(require, "lspsaga")
			if not status then
				return
			end

			saga.setup({
				ui = {
					winblend = 10,
					border = "rounded",
				},
				lightbulb = {
					enable = false,
					sign = false,
				},
			})

			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
			vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
			vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
			vim.keymap.set("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
			vim.keymap.set("n", "go", "<Cmd>Lspsaga outline<CR>", opts)
			vim.keymap.set("n", "gf", "<Cmd>Lspsaga finder<CR>", opts)
			vim.keymap.set("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", opts)
			vim.keymap.set("n", "gl", "<Cmd>Lspsaga show_buf_diagnostics<CR>", opts)

			-- code action
			local codeaction = require("lspsaga.codeaction")
			vim.keymap.set("n", "<leader>ca", function()
				codeaction:code_action()
			end, { silent = true })

			vim.keymap.set("v", "<leader>ca", function()
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
				codeaction:range_code_action()
			end, { silent = true })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local nvim_lsp = require("lspconfig")

			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end
				local function buf_set_option(...)
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				-- Enable completion triggered by <c-x><c-o>
				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mappings.
				local opts = { noremap = true, silent = true }

				-- See `:help vim.lsp.*` for documentation on any of the below functions
				buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
				buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
				buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
				buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
				buf_set_keymap(
					"n",
					"<space>wl",
					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					opts
				)
				buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
				buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
				buf_set_keymap("n", "g?", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
				buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
				buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
				buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
				buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
			end

			-- nvim-cmp supports additional completion capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Enable LSP
			local servers = {
				"tsserver",
				"gopls",
				"intelephense",
				"terraformls",
				"tflint",
				"vimls",
				"tailwindcss",
				"lua_ls",
				"cssls",
				"cssmodules_ls",
			}

			for _, lsp in ipairs(servers) do
				nvim_lsp[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			nvim_lsp.volar.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "vue" },
			})

			nvim_lsp.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},

	-- File explorer
	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				view = {
					adaptive_size = true,
					side = "left",
				},
				renderer = {
					group_empty = true,
					icons = {
						show = {
							folder = false,
							file = false,
						},
					},
				},
				filters = {
					dotfiles = false,
					custom = {
						"^.git$",
					},
				},
				update_focused_file = {
					enable = true,
					update_root = false,
					ignore_list = {},
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					api.config.mappings.default_on_attach(bufnr)

					vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
					vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
					vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
					vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
				end,
			})
			-- Key maps
			vim.keymap.set("n", "cc", ":NvimTreeToggle<CR>", { noremap = true })
		end,
	},

	-- autopair
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
				},
			})

			vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp" },

	{
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init({
				mode = "symbol",
			})
		end,
	},

	{ "nvim-lua/plenary.nvim" },

	-- Fuzzy finder
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { ".git/" },
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"L3MON4D3/LuaSnip",
	},

	-- formatting
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					javascriptreact = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					go = { "gofmt" },
				},

				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				},
			})
		end,
	},

	-- lintting
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 2, -- 0 = just filename, 1 = relative path, 2 = absolute path
						},
					},
				},
			})
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				user_default_options = {
					names = false,
					mode = "virtualtext",
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			-- options
		},
	},
	{ "vim-scripts/sessionman.vim" },
	{ "tpope/vim-commentary" },

	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},

	-- vim for golang
	{
		"fatih/vim-go",
		config = function()
			-- we disable most of these features because treesitter and nvim-lsp
			-- take care of it
			vim.g["go_gopls_enabled"] = 0
			vim.g["go_code_completion_enabled"] = 0
			vim.g["go_fmt_autosave"] = 0
			vim.g["go_imports_autosave"] = 0
			vim.g["go_mod_fmt_autosave"] = 0
			vim.g["go_doc_keywordprg_enabled"] = 0
			vim.g["go_def_mapping_enabled"] = 0
			vim.g["go_textobj_enabled"] = 0
			vim.g["go_list_type"] = "quickfix"
		end,
	},
})

--------------
-- SETTINGS --
--------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.clipboard = "unnamedplus" -- copy/paste to system clipboard
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "uft-8"
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- use relative numbers
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.modifiable = true
vim.opt.shell = "fish"
vim.opt.inccommand = "split"
vim.opt.backup = false

-- indent settings
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = false
vim.opt.mouse = "a" -- enable mouse support in all modes

-- fold settings
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false

-- diagnostic
vim.diagnostic.config({
	virtual_text = false, -- do not show the virtual text
	signs = true,
	underline = true,
	-- update diagnostic in insert mode will be annoying when the output is too verbose
	update_in_insert = true,
})

----------------
--  MAPPINGS  --
----------------

-- better split switching
vim.keymap.set("", "<C-j>", "<C-W>j")
vim.keymap.set("", "<C-k>", "<C-W>k")
vim.keymap.set("", "<C-h>", "<C-W>h")
vim.keymap.set("", "<C-l>", "<C-W>l")

-- save, escape while in insert mode
vim.keymap.set("i", "ww", "<Esc>:w<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- copy & paste to/from system clipboard
vim.keymap.set("n", "<C-c>", '"*y')
vim.keymap.set("n", "<C-v>", '"*p')

-- easily switch between tab
vim.keymap.set("n", "H", "gT")
vim.keymap.set("n", "L", "gt")

-- quickly source init.lua
vim.keymap.set("n", "<leader>sv", ":source ~/.config/nvim/init.lua<CR>")

-- center the screen
vim.keymap.set("n", "<space>", "zz")

-- remove search highlighting
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>")

-- finding color schema code
vim.cmd([[
nnoremap <leader>1 :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
\ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
\ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
\ . ">"<CR>
]])

vim.keymap.set("n", "w", ":b<space>")
vim.keymap.set("n", "e", ":e<space>")

-- vim-session
vim.keymap.set("n", "sv", ":SessionSave<CR>")
vim.keymap.set("n", "ss", ":SessionOpen<space>")

-- toggle wrap
vim.keymap.set("n", "<leader>z", ":set wrap!<CR>")

-- reindent
vim.keymap.set("n", "<leader>re", "gg=G")

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "ff", builtin.find_files, {})
vim.keymap.set("n", ";g", builtin.git_files, {})
vim.keymap.set("n", ";r", builtin.live_grep, {})
vim.keymap.set("n", ";e", builtin.diagnostics, {})
vim.keymap.set("n", ";;", builtin.resume, {})
vim.keymap.set("n", ";t", builtin.help_tags, {})

-- other-nvim
vim.keymap.set("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true, desc = "other-vim" })
vim.keymap.set("n", "<leader>lp", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- quickly switching buffers
vim.keymap.set("n", "<C-n>", "<cmd>:bnext<cr>")
vim.keymap.set("n", "<C-p>", "<cmd>:bprevious<cr>")

-- Add description to key bindings
local wk = require("which-key")
wk.register({
	[";g"] = { "Fuzzy search through the output of git ls-files" },
	[";e"] = { "Search for a string using ripgrep" },
})
