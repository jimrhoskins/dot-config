return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest',
  },
  event = 'BufWinEnter',
  config = function()
    local keymap = vim.keymap
    local neotest = require 'neotest'
    neotest.setup {
      adapters = {
        require 'neotest-jest' {},
      },
    }

    keymap.set('n', 'tt', function()
      require('neotest').run.run()
    end, { desc = 'Run nearest test' })

    keymap.set('n', 'tf', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, { desc = 'Run tests in file' })

    keymap.set('n', 'ta', function()
      require('neotest').run.attach()
    end, { desc = 'Attach to test' })

    keymap.set('n', 'tp', function()
      require('neotest').output_panel.toggle()
    end, { desc = 'Toggle test panel' })
  end,
}
