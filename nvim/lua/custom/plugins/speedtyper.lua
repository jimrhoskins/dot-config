return {
  'NStefan002/speedtyper.nvim',
  lazy = false,
  branch = 'v2',
  config = function()
    require('speedtyper').setup()

    local keymap = vim.keymap
    keymap.set('n', '<leader>mt', '<cmd>SpeedTyper<CR>', { desc = 'Start Monkeytype' })
  end,
}
