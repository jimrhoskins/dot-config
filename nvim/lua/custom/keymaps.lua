local keymap = vim.keymap

keymap.set('i', 'jk', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('i', 'jj', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('i', 'kk', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('n', '<leader>fs', '<cmd>w<CR>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'Save file' })

local function toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
end

keymap.set('n', '<leader>tw', toggle_wrap, { silent = true, noremap = true, expr = false, nowait = false, desc = 'Toggle wrap' })
