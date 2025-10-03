return {
  'AckslD/nvim-neoclip.lua',
  dependencies = {
    { 'kkharji/sqlite.lua', module = 'sqlite' },
    { 'nvim-telescope/telescope.nvim' },
  },
  config = function()
    require('neoclip').setup()

    local keymap = vim.keymap
    keymap.set('n', '<leader>fp', ':Telescope neoclip<cr>', { desc = 'Paste from Neoclip' })
  end,
}
