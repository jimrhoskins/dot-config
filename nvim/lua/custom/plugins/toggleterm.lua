return {

  {
    'akinsho/toggleterm.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function()
      require('toggleterm').setup {}
      local Terminal = require('toggleterm.terminal').Terminal
      local opts = {
        hidden = true,
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }

      local lazygit = Terminal:new(vim.tbl_extend('force', opts, { cmd = 'lazygit' }))
      local k9s = Terminal:new(vim.tbl_extend('force', opts, { cmd = 'k9s' }))

      local function toggle(term)
        return function()
          term:toggle()
        end
      end

      vim.keymap.set('n', '<leader>tg', toggle(lazygit), { desc = 'Lazy[G]it', silent = true })
      vim.keymap.set('n', '<leader>gg', toggle(lazygit), { desc = 'Lazy[G]it', silent = true })
      vim.keymap.set('n', '<leader>tk', toggle(k9s), { desc = '[K]9s', silent = true })

      vim.api.nvim_create_user_command('Lazygit', toggle(lazygit), {})
      vim.api.nvim_create_user_command('K9s', toggle(k9s), {})
    end,
  },
}
