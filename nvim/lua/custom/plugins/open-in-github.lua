return {
  'almo7aya/openingh.nvim',
  config = function()
    require('openingh').setup()

    local keymap = vim.keymap
    keymap.set('n', '<leader>gr', '<cmd>OpenInGHRepo<cr>', { desc = 'Open [G]itub [R]epository' })
    keymap.set('n', '<leader>gf', '<cmd>OpenInGHFile<cr>', { desc = 'Open [G]ithub [F]ile' })
    keymap.set('v', '<leader>gl', '<cmd>OpenInGHLines<cr>', { desc = 'Open [G]ithub to [L]ine' })
  end,
}
