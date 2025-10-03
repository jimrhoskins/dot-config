return {
  "nvim-neotest/neotest",
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace "neotest"
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)
    require("neotest").setup {
      -- your neotest config here
      adapters = {
        -- require "neotest-go",
        -- require "neotest-rust",
        -- require "neotest-python",
        require('neotest-jest')({
          -- jestCommand = "npm test --",
          -- jestConfigFile = "custom.jest.config.ts",
          -- env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
      },
    }
  end,
  ft = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  dependencies = {
    "haydenmeade/neotest-jest",
    -- "nvim-neotest/neotest-go",
    -- "nvim-neotest/neotest-python",
    -- "rouge8/neotest-rust",
  },
}
