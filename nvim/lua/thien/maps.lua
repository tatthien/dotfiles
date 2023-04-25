-- Better split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- Save, escape while in insert mode
vim.keymap.set('i', 'ww', '<Esc>:w<CR>')
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Copy & paste to/from system clipboard
vim.keymap.set('n', '<C-c>', '"*y')
vim.keymap.set('n', '<C-v>', '"*p')

-- Easily switch between tab
vim.keymap.set('n', 'H', 'gT')
vim.keymap.set('n', 'L', 'gt')

-- Quickly source init.lua
vim.keymap.set('n', '<leader>sv', ':source ~/.config/nvim/init.lua<CR>')

-- Center the screen
vim.keymap.set('n', '<space>', 'zz')

-- Remove search highlighting
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>')

-- Nvim Tree
vim.keymap.set('n', 'cc', ':NvimTreeFindFileToggle<CR>')

-- Finding color schema code
vim.cmd [[
nnoremap <leader>1 :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
      \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
      \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
      \ . ">"<CR>
]]

vim.keymap.set('n', 'w', ':b<space>')
vim.keymap.set('n', 'e', ':e<space>')

-- Session
vim.keymap.set('n', 'sv', ':SessionSave<CR>')
vim.keymap.set('n', 'ss', ':SessionOpen<space>')

