return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require('oil').setup {}

      local keymap = vim.keymap
      keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open Oil' })

      -- vim.api.nvim_create_autocmd('VimEnter', {
      --   desc = 'Open Oil in the final cwd when starting with no args',
      --   callback = function(ev)
      --     if vim.fn.argc() > 0 then
      --       return
      --     end
      --     -- let other plugins (project.nvim, etc.) finish changing cwd
      --     vim.defer_fn(function()
      --       local dir = vim.loop.cwd() -- final cwd after all autocmds
      --       -- using the :Oil command ensures a proper refresh
      --       vim.cmd('silent keepalt Oil ' .. vim.fn.fnameescape(dir))
      --     end, 20)
      --   end,
      -- })
      -- vim.api.nvim_create_autocmd('VimEnter', {
      --   callback = function(data)
      --     local dir = vim.fn.isdirectory(data.file) == 1 and data.file or vim.fn.getcwd()
      --     require('oil').open(dir)
      --   end,
      -- })
    end,
  },
}
