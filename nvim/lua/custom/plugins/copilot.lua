return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-n>',
          prev = '<C-p>',
        },
      },
      filetypes = {
        yaml = true,
        hcl = true,
        toml = true,
      },
    }
  end,
}
