-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Easily switch between tab
keymap.set("n", "te", ":tabedit<CR>", opts)
keymap.set("n", "L", ":tabnext<CR>", opts)
keymap.set("n", "H", ":tabprev<CR>", opts)

-- Save, escape while in insert mode
keymap.set("i", "jj", "<Esc>")
keymap.set("i", "jk", "<Esc>")

-- Center the screen
keymap.set("n", "<space>", "zz")

-- Toggle wrap
keymap.set("n", "<leader>z", ":set wrap!<CR>")

-- Split window
keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)

-- Move lines
keymap.set("n", "<down>", ":m +1<CR>==")
keymap.set("n", "<up>", ":m .-2<CR>==")
keymap.set("v", "<down>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<up>", ":m '<-2<CR>gv=gv")
keymap.set("i", "<down>", "<Esc>:m .+1<CR>==gi")
keymap.set("i", "<up>", "<Esc>:m .-2<CR>==gi")

-- Save file
keymap.set("i", "ww", "<Esc>:w<CR>")
