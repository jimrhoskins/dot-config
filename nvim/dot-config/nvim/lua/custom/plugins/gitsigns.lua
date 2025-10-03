return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = 'BufRead',
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
  },
  keys = {
    { '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>', 'n', desc = '[T]oggle current line [b]lame' },
  },
}
