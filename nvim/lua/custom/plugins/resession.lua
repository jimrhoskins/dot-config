return {
  'stevearc/resession.nvim',
  config = function()
    local resession = require 'resession'
    resession.setup {}

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save 'last'
      end,
    })

    local keymap = vim.keymap

    keymap.set('n', '<leader>Ss', resession.save, { desc = 'Save session' })
    keymap.set('n', '<leader>Sl', function()
      resession.load 'last'
    end, { desc = 'Load session' })
  end,
}
