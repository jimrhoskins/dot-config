return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function()
    require('neo-tree').setup {}
    local command = require 'neo-tree.command'
    local keymap = vim.keymap

    keymap.set('n', '<leader>ee', '<cmd>Neotree toggle left <cr>', { desc = 'Filetre[e]' })
    keymap.set('n', '<leader>ef', '<cmd>Neotree reveal toggle left  <cr>', { desc = 'Filetre[e] [F]ocus' })
  end,
}
