return {
  -- Autocolorize #0099FF
  { 'NvChad/nvim-colorizer.lua', name = 'colorizer', opts = {} },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
}
