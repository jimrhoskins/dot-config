return {
  'someone-stole-my-name/yaml-companion.nvim',
  ft = { 'yaml' },
  dependencies = {
    { 'neovim/nvim-lspconfig' },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
  },
  config = function()
    local cfg = require('yaml-companion').setup {}

    require('lspconfig')['yamlls'].setup(cfg)
    require('telescope').load_extension 'yaml_schema'

    vim.keymap.set('n', '<leader>fy', '<cmd>Telescope yaml_schema<CR>', { noremap = true, silent = true, desc = 'Find YAML schema' })
  end,
}
