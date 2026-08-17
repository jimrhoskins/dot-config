return {
  dir = '/Users/jimhoskins/dev/ghreview',
  name = 'ghreview.nvim',
  dependencies = { 'sindrets/diffview.nvim' },
  config = function()
    require('ghreview').setup {
      show_virtual_text = true,
    }
  end,
}
