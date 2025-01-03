return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function()
    require('neo-tree').setup {
      popup_border_style = 'rounded',
      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            -- ".DS_Store",
            -- "thumbs.db",
            --"node_modules",
          },
          hide_by_pattern = {
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --".DS_Store",
            --"thumbs.db",
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
      },
    }

    local keymap = vim.keymap

    keymap.set('n', '<leader>ee', '<cmd>Neotree toggle left <cr>', { desc = 'Filetre[e]' })
    keymap.set('n', '<leader>ef', '<cmd>Neotree reveal toggle left  <cr>', { desc = 'Filetre[e] [F]ocus' })
    keymap.set('n', '<leader>ep', '<cmd>Neotree reveal float  <cr>', { desc = 'Filetre[e] [P]opup' })
  end,
}
