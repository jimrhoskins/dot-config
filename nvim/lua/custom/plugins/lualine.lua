return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'SmiteshP/nvim-navic',
    'neovim/nvim-lspconfig',
  },
  config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status' -- to configure lazy pending updates count

    require('nvim-navic').setup {
      lsp = {
        auto_attach = true,
      },
      separator = ' \u{e0b1} ',
      highlight = true,
    }

    -- configure lualine with modified theme
    lualine.setup {
      -- options = {
      --   theme = my_lualine_theme,
      -- },
      winbar = {
        lualine_c = {
          { 'navic', separator = '' },
          {
            function()
              return ' '
            end,
          },
        },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(mode)
              return mode:sub(1, 1):upper()
            end,
          },
        },
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = '#ff9e64' },
          },
          { 'encoding' },
          --{ 'fileformat' },
          { 'filetype' },
        },
      },
    }
  end,
}
