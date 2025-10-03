return { -- You can easily change to a different colorscheme.
  'folke/tokyonight.nvim',
  'rebelot/kanagawa.nvim',
  'kepano/flexoki-neovim',
  'tanvirtin/monokai.nvim',
  'Mofiqul/dracula.nvim',
  { 'rose-pine/neovim', name = 'rose-pine' },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 999, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
