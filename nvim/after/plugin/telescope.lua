function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
  },
}

local opts = { noremap = true, silent = true }

vim.keymap.set('n', 'ff', 
  function() 
    builtin.find_files({
      no_ignoreee = false,
      hidden = true
    })
  end
, opts)

vim.keymap.set('n', ';r', 
  function() 
    builtin.live_grep()
  end
, opts)

vim.keymap.set('n', '\\', 
  function() 
    builtin.buffers()
  end
, opts)


vim.keymap.set('n', ';e', 
  function() 
    builtin.diagnostics()
  end
, opts)

vim.keymap.set('n', ';;', 
  function() 
    builtin.resume()
  end
, opts)

vim.keymap.set('n', ';t', 
  function() 
    builtin.help_tags()
  end
, opts)
