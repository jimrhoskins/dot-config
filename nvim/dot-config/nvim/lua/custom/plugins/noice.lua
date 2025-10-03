-- lazy.nvim
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      'rcarriga/nvim-notify',
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('notify').setup {
          background_colour = '#000000',
        }
      end,
    },
  },
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      --      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  config = function(_, opts)
    require('noice').setup(opts)

    local keymap = vim.keymap
    keymap.set('n', '<leader>nn', '<cmd>Noice<cr>', { desc = 'Noice' })
    keymap.set('n', '<leader>na', '<cmd>Noice all<cr>', { desc = 'Noice All' })
    keymap.set('n', '<leader>nl', '<cmd>Noice last<cr>', { desc = 'Noice Last' })
    keymap.set('n', '<leader>fm', '<cmd>Noice telescope<cr>', { desc = '[F]ind [M]essages' })
    keymap.set('n', '<esc>', '<cmd>Noice dismiss<cr>', { desc = 'Dismiss messages' })
  end,
}
