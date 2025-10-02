return {
  'declancm/maximize.nvim',
  config = function()
    local maximize = require 'maximize'

    vim.keymap.set('n', '<leader>z', maximize.toggle, { desc = 'Maximi[z]e' })
  end,
}
