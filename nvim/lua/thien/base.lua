vim.opt.termguicolors = true
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.scriptencoding = 'uft-8'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.modifiable = true
vim.opt.shell = 'fish'
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false
vim.opt.swapfile = false

local color_palette = {
	rosewater = "#F5E0DC",
	flamingo = "#F2CDCD",
	pink = "#F5C2E7",
	mauve = "#CBA6F7",
	red = "#F38BA8",
	maroon = "#EBA0AC",
	peach = "#FAB387",
	yellow = "#F9E2AF",
	green = "#A6E3A1",
	teal = "#94E2D5",
	sky = "#89DCEB",
	sapphire = "#74C7EC",
	blue = "#89B4FA",
	lavender = "#B4BEFE",
	text = "#CDD6F4",
	subtext1 = "#BAC2DE",
	subtext0 = "#A6ADC8",
	overlay2 = "#9399B2",
	overlay1 = "#7F849C",
	overlay0 = "#6C7086",
	surface2 = "#585B70",
	surface1 = "#45475A",
	surface0 = "#313244",
	base = "#1E1E2E",
	mantle = "#181825",
	crust = "#11111B",
}

-- Vimwiki configuration
vim.cmd(string.format([[ let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}] ]]))

-- Custom highlighting
local function hi(group, fg, bg, style)
  vim.cmd(string.format(
    [[ hi %s guifg=%s guibg=%s gui=%s ]],
    group, fg, bg, style
  ))
end

hi("VimwikiLink", color_palette.sky, color_palette.base, "underline")
hi("VimwikiPre", color_palette.overlay2, color_palette.base, "none")

