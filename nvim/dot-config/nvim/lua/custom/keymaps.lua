local keymap = vim.keymap

keymap.set('i', 'jk', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('i', 'jj', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('i', 'kk', '<Esc>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'jk to escape' })
keymap.set('n', '<leader>fs', '<cmd>w<CR>', { silent = true, noremap = true, expr = false, nowait = false, desc = 'Save file' })

keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move line down' })
keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move line up' })

keymap.set('n', '<leader>lX', '<cmd>source %<CR>')
keymap.set('n', '<leader>lx', ':.lua<CR>')
keymap.set('v', '<leader>lx', ':lua<CR>')

keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>')
keymap.set('n', '<leader>dw', '<cmd>DiffviewOpen<CR>')
keymap.set('n', '<leader>db', '<cmd>DiffviewOpen origin/develop...HEAD<CR>')

local function toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
end

keymap.set('n', '<leader>tw', toggle_wrap, { silent = true, noremap = true, expr = false, nowait = false, desc = 'Toggle wrap' })
vim.g['diagnostics_active'] = true
function Toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.enable(false)
  else
    vim.g.diagnostics_active = true
    vim.diagnostic.enable(true)
  end
end

vim.keymap.set('n', '<leader>td', Toggle_diagnostics, { noremap = true, silent = true, desc = 'Toggle vim diagnostics' })
