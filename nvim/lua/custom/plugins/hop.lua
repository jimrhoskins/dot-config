return {
  'smoka7/hop.nvim',
  version = '*',
  opts = {
    keys = 'etovxqpdygfblzhckisuran',
    yank_register = '+',
  },
  config = function(_, opts)
    require('hop').setup(opts)

    local hop = require 'hop'
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 'f', function()
      hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
    end, { remap = true })
    vim.keymap.set('', 'F', function()
      hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
    end, { remap = true })
    vim.keymap.set('', 't', function()
      hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }
    end, { remap = true })
    vim.keymap.set('', 'T', function()
      hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }
    end, { remap = true })
    -- description for <leader>h
    require('which-key').add {
      { '<leader>h', group = '[H]op' },
    }
    vim.keymap.set('n', '<leader>hc', '<cmd>HopChar1<cr>', { desc = 'Hop 1 character' })
    vim.keymap.set('n', '<leader>hw', '<cmd>HopWord<cr>', { desc = 'Hop to word' })
    vim.keymap.set('n', '<leader>hp', '<cmd>HopPattern<cr>', { desc = 'Hop to pattern' })
    vim.keymap.set('n', '<leader>hl', '<cmd>HopLine<cr>', { desc = 'Hop to line' })
    vim.keymap.set('n', '<leader>ha', '<cmd>HopLine<cr>', { desc = 'Hop to anywhere' })
    vim.keymap.set('n', '<leader>hv', '<cmd>HopPasteChar1<cr>', { desc = 'Paste at character' })
    vim.keymap.set('n', '<leader>hy', '<cmd>HopYankChar1<cr>', { desc = 'Yank at character' })
  end,
}
