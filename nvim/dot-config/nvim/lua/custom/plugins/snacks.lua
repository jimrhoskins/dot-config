return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        preset = 'telescope',
      },
    },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  -- stylua: ignore start
  keys = {
    {'<leader>tD', function() Snacks.dim() end, desc = 'Toggle Dim'},
    {'<leader>ef', function() Snacks.explorer() end, desc = 'Open Explorer'},

    {'<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Picker'},
    {'<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files'},
    {'<leader>fF', function() Snacks.picker.files({
      hidden = true,
      ignored = true,
    }) end, desc = 'Find All Files'},
    {'<leader>fh', function() Snacks.picker.help() end, desc = 'Find Help'},
    {'<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Find Keymaps'},
    {'<leader>fj', function() Snacks.picker.git_files() end, desc = 'Find Git jfiles'},
    {'<leader>fb', function() Snacks.picker.pickers() end, desc = 'Find Builtins'},
    {'<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Find Word'},
    {'<leader>fg', function() Snacks.picker.grep() end, desc = 'Live Grep'},
    {'<leader>fG', function() Snacks.picker.grep({
      hidden = true,
      ignored = true,
    }) end, desc = 'Live Grep All'},
    {'<leader>fd', function() Snacks.picker.diagnostics() end, desc = 'Find Diagnostics'},
    {'<leader>fD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Find Diagnostics in Buffer'},
    {'<leader>fr', function() Snacks.picker.resume() end, desc = 'Resume Find'},
    {'<leader>f.', function() Snacks.picker.recent() end, desc = 'Find Recent'},
    {'<leader>/' , function() Snacks.picker.lines() end, desc = 'Fuzzy Find in File'},
    {'<leader>f/', function() Snacks.picker.grep_buffers() end, desc = 'Grep in Buffers'},
---@diagnostic disable-next-line: assign-type-mismatch
    {'<leader>fn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config'), }) end, desc = 'Find Neovim Config'},
    {'<leader>fc', function() Snacks.picker.colorschemes({ layout = 'ivy', }) end, desc = 'Find Colorschemes'},
  },
  -- stylua: ignore end
}
