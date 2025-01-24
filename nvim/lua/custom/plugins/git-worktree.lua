return {
  'ThePrimeagen/git-worktree.nvim',
  config = function()
    require('git-worktree').setup {}

    require('telescope').load_extension 'git_worktree'
    local keymap = vim.keymap
    keymap.set('n', '<leader>wt', function()
      require('telescope').extensions.git_worktree.git_worktrees()
    end, { desc = 'Switch Git Worktree' })
    keymap.set('n', '<leader>wc', function()
      require('telescope').extensions.git_worktree.create_git_worktree()
    end, { desc = 'Create Git Worktree' })
  end,
}
