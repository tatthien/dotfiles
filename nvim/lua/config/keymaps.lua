local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Better split switching
-- These key maps are not used anymore since I'm using vim-tmux-navigator.
-- keymap.set("", "<C-j>", "<C-W>j")
-- keymap.set("", "<C-k>", "<C-W>k")
-- keymap.set("", "<C-h>", "<C-W>h")
-- keymap.set("", "<C-l>", "<C-W>l")

-- Save, escape while in insert mode
keymap.set("i", "jj", "<Esc>")
keymap.set("i", "jk", "<Esc>")

-- Copy & paste to/from system clipboard
-- Select the text and press C-c to copy to clipboard
-- Press C-v to paste from clipboard
vim.cmd([[
noremap <C-c> "*y
noremap <C-v> "*p
]])

-- Easily switch between tab
keymap.set("n", "te", ":tabedit<CR>", opts)
keymap.set("n", "L", ":tabnext<CR>", opts)
keymap.set("n", "H", ":tabprev<CR>", opts)

-- Center the screen
keymap.set("n", "<space>", "zz")

-- Remove search highlighting
keymap.set("n", "<leader><space>", ":nohlsearch<CR>")

-- Finding color schema code
vim.cmd([[
nnoremap <leader>1 :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
\ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
\ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
\ . ">"<CR>
]])

-- Open buffers list
keymap.set("n", "w", ":b<space>")

-- Open file exlorer
keymap.set("n", "e", ":e<space>")

-- Toggle wrap
keymap.set("n", "<leader>z", ":set wrap!<CR>")

-- Quickly switching buffers
keymap.set("n", "<C-n>", "<cmd>:bnext<cr>")
keymap.set("n", "<C-p>", "<cmd>:bprevious<cr>")

-- Split window
keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)

-- Syntax highlight
-- vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = colors.comment })

-- Move lines
keymap.set("n", "<down>", ":m +1<CR>==")
keymap.set("n", "<up>", ":m .-2<CR>==")
keymap.set("v", "<down>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<up>", ":m '<-2<CR>gv=gv")
keymap.set("i", "<down>", "<Esc>:m .+1<CR>==gi")
keymap.set("i", "<up>", "<Esc>:m .-2<CR>==gi")

-- Save file
keymap.set("i", "ww", "<Esc>:w<CR>")
keymap.set("n", "<C-s>", ":w<CR>")
