return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').add {
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>f', group = '[F]ind' },
      { '<leader>e', group = '[E]rrors' },
      { '<leader>l', group = '[L]ua' },
      { '<leader>g', group = '[G]it' },
      { '<leader>m', group = '[M]onkeytype' },
      { '<leader>n', group = '[N]oice' },
      { '<leader>S', group = '[S]ession' },
    } -- Document existing key chains
  end,
}
