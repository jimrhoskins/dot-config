return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-n>',
          prev = '<C-p>',
        },
      },
      filetypes = {
        yaml = true,
        speedtyper = false,
      },
    }

    local keymap = vim.keymap
    keymap.set('n', '<leader>cpe', '<cmd>Copilot enable<CR>', { desc = 'Copilot enable' })
    keymap.set('n', '<leader>cpd', '<cmd>Copilot disable<CR>', { desc = 'Copilot disable' })
    keymap.set('n', '<leader>cpt', '<cmd>Copilot toggle<CR>', { desc = 'Copilot toggle' })
  end,
}
