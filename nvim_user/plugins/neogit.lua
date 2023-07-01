return {
  {
    "TimUntersberger/neogit",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "VimEnter",
    keys = {
      { "<leader>gs", "<cmd>Neogit<CR>", desc = "Open Neogit Tab Page" },
      { "<leader>gnt", "<cmd>Neogit<CR>", desc = "Open Neogit Tab Page" },
    },
  }
}

