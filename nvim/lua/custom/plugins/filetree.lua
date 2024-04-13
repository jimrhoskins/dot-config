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
    vim.keymap.set('n', '<leader>ft', ':NeoTreeRevealToggle<cr>', { desc = 'Filetre[e]' })
    vim.keymap.set('n', '<leader>fT', ':NeoTreeFloatToggle<cr>', { desc = 'Filetre[e]' })
  end,
}
