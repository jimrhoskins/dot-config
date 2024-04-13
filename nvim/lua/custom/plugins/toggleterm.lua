return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {--[[ things you want to change go here]]
    },
    config = function()
      require('toggleterm').setup {}
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        hidden = true,
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }

      local function lazygit_toggle()
        lazygit:toggle()
      end
      vim.keymap.set('n', '<leader>tg', lazygit_toggle, { desc = 'Lazy[G]it', silent = true })

      -- vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
    end,
  },
}
