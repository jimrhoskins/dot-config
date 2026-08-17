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

    local function is_diffview_window()
      local ok, lib = pcall(require, 'diffview.lib')
      if ok and lib and type(lib.get_current_view) == 'function' then
        local view = lib.get_current_view()
        if view and view.tabpage == vim.api.nvim_get_current_tabpage() then
          return true
        end
      end

      local ft = vim.bo.filetype
      if ft == 'DiffviewFiles' or ft == 'DiffviewFileHistory' then
        return true
      end

      if vim.wo.diff then
        return true
      end

      local name = vim.api.nvim_buf_get_name(0)
      return name:match('^diffview://') ~= nil
    end

    require('nvim-navic').setup {
      lsp = {
        auto_attach = true,
      },
      separator = ' \u{e0b1} ',
      highlight = true,
    }

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        disabled_filetypes = {
          winbar = { 'DiffviewFiles', 'DiffviewFileHistory' },
        },
      },
      winbar = {
        lualine_c = {
          {
            'navic',
            separator = '',
            cond = function()
              return not is_diffview_window()
            end,
          },
          {
            function()
              return ' '
            end,
            cond = function()
              return not is_diffview_window()
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
