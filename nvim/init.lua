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
      'nvim-treesitter/nvim-treesitter-textobjects',
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
          "vimdoc" ,
          "vim",
          "bash",
          "lua",
				},
				highlight = {
					enable = true,
          -- Disable slow treesitter highlight for large files
          disable = function(lang, buf)
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
	{ "nvim-treesitter/nvim-treesitter-textobjects" }, {
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
          sign = false
        }
			})

			local diagnostic = require("lspsaga.diagnostic")
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
			vim.keymap.set("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
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
			local protocol = require("vim.lsp.protocol")

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
				buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
				buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
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
				buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
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
			local servers = { "tsserver", "gopls", "intelephense", "terraformls", "tflint", "vimls", "tailwindcss" }
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
		end,
	},

	-- Lsp manager
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	-- nvim-tree
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
					dotfiles = true,
					custom = {
						"^.git$",
					},
				},
				update_focused_file = {
					enable = true,
					update_root = false,
					ignore_list = {},
				},
				actions = {
					open_file = {
						quit_on_open = true,
					},
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
				end,
			})
      -- Key maps
      vim.keymap.set("n", "cc", ":NvimTreeToggle<CR>", { noremap = true })
		end,
	},

	-- colorschema
  { 
    "ellisonleao/gruvbox.nvim", 
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function ()
      require("gruvbox").setup({
        contrast = "hard"
      })
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				map_cr = true,
				map_complete = true,
				disable_filetype = { "TelescopePrompt", "vim" },
				enable_check_bracket_line = false,
			})
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
				mode = "symbol_text",
				preset = "codicons",
				symbol_map = {},
			})
		end,
	},
	{
		"folke/lsp-colors.nvim",
		config = function()
			require("lsp-colors").setup({
				Error = "#db4b4b",
				Warning = "#e0af68",
				Information = "#0db9d7",
				Hint = "#10B981",
			})
		end,
	},
	{ "nvim-lua/plenary.nvim" },

	-- telescope
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
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = function(opts)
							return { "--hidden" }
						end,
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
	{ "onsails/lspkind-nvim" },
  {
    "L3MON4D3/LuaSnip",
  },
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local status, null_ls = pcall(require, "null-ls")
			if not status then
				return
			end

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			local lsp_formatting = function(bufnr)
				vim.lsp.buf.format({
					filter = function(client)
						return client.name == "null-ls"
					end,
					bufnr = bufnr,
				})
			end

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.diagnostics.eslint_d.with({
						diagnostics_format = "[eslint] #{m}\n(#{c})",
					}),
					null_ls.builtins.diagnostics.fish,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								lsp_formatting(bufnr)
							end,
						})
					end
				end,
			})

			vim.api.nvim_create_user_command("DisableLspFormatting", function()
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
			end, { nargs = 0 })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
	{ "tpope/vim-fugitive" },

	-- vimwiki
	{
		"vimwiki/vimwiki",
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/code/github.com/tatthien/digital-garden/docs",
          index = "sitemap",
					syntax = "markdown",
					ext = ".md",
				},
			}
		end,
	},
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
vim.opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "uft-8"
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Use relative numbers
vim.opt.autoread = true
vim.opt.swapfile = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.modifiable = true
vim.opt.shell = "fish"
vim.opt.inccommand = "split"

-- indent settings
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = false
vim.opt.mouse = "a" -- Enable mouse support

-- fold settings
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false

-- theme tweaks
local color_palette = {
	-- rosewater = "#F5E0DC",
	-- flamingo = "#F2CDCD",
}

-- shortcut for hightlighting
local function hi(group, fg, bg, style)
	vim.cmd(string.format([[ hi %s guifg=%s guibg=%s gui=%s ]], group, fg, bg, style))
end

-- hi("VimwikiLink", color_palette.sky, color_palette.base, "underline")
-- hi("VimwikiPre", color_palette.overlay2, color_palette.base, "none")

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
vim.keymap.set("n", "\\", builtin.buffers, {})

-- other-nvim
vim.keymap.set("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lp", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- diagnostic
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  -- -- update diagnostic in insert mode will be annoying when the output is too verbose
  update_in_insert = true,
})
