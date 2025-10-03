return {
  'comatory/gh-co.nvim',
  config = function()
    local keymap = vim.keymap

    keymap.set('n', '<leader>gc', '<cmd>GhCoWho<CR>', { desc = 'Show Code Owners' })
  end,
}
