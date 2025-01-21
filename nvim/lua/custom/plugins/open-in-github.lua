return {
  'almo7aya/openingh.nvim',
  config = function()
    vim.g.openingh_copy_to_register = true
    require('openingh').setup()

    local keymap = vim.keymap
    keymap.set('n', '<leader>gr', '<cmd>OpenInGHRepo<cr>', { desc = 'Open [G]itub [R]epository' })
    keymap.set('n', '<leader>gR', '<cmd>OpenInGHRepo+<cr>', { desc = 'Open [G]itub [R]epository' })

    keymap.set('n', '<leader>gh', '<cmd>OpenInGHFile<cr>', { desc = 'Open [G]ithub [F]ile' })
    keymap.set('n', '<leader>gH', '<cmd>OpenInGHFile+<cr>', { desc = 'Open [G]ithub [F]ile' })

    -- Needs to use ':' to work in visual mode
    keymap.set('v', '<leader>gh', ':OpenInGHFileLines<cr>', { desc = 'Open [G]ithub to [L]ine', silent = true, noremap = true })
    keymap.set('v', '<leader>gH', ':OpenInGHFileLines +<cr>', { desc = 'Open [G]ithub to [L]ine', silent = true, noremap = true })
  end,
}
