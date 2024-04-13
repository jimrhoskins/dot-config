local keymap = vim.keymap

keymap.set('i', 'jk', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('n', 'fs', '<cmd>w<CR>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'Save file' })
