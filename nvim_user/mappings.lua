-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(
            bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    ["<leader>fs"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
    ["<leader><Tab>"] = { ":e#<cr>", desc = "Alternate File", silent = true },
    ["<leader><leader>"] = { ":Telescope buffers<cr>" },
    ["<leader>tb"] = { ":GitBlameToggle<cr>", desc = "[T]oggle [B]lame" },

    ["<leader>x"] = { name = "Test" },
    ["<leader>xp"] = { require('neotest').output_panel.toggle, desc = "Toggle Test Panel" },
    ["<leader>xt"] = { require('neotest').run.run, desc = "Run nearest test" },
    ["<leader>xa"] = { require('neotest').run.attach, desc = "Attach to nearest test" },
    ["<leader>xx"] = {
      function() require('neotest').run.run(vim.fn.expand("%")) end,
      desc = "Run all tests"
    },


    -- Window Navigation
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
