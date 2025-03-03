return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    adapters = {
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = {
            api_key = 'cmd:cat ~/.credentials/openai.txt',
          },
        })
      end,
    },
  },
  config = function(_, opts)
    require('codecompanion').setup(opts)

    local keymap = vim.keymap
    keymap.set({ 'n', 'v' }, '<leader>cd', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
    keymap.set({ 'n', 'v' }, '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
    keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
