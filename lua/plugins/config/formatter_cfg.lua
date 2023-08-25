-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      -- function()
        -- Supports conditional formatting
        -- if util.get_current_buffer_file_name() == "special.lua" then
        --   return nil
        -- end

        -- Full specification of configurations is down below and in Vim help
        -- files
      --   return {
      --     exe = "stylua",
      --     args = {
      --       "--search-parent-directories",
      --       "--stdin-filepath",
      --       util.escape_path(util.get_current_buffer_file_path()),
      --       "--",
      --       "-",
      --     },
      --     stdin = true,
      --   }
      -- end
    },
    python = {
      require("formatter.filetypes.python").isort,
      require("formatter.filetypes.python").black,
    },
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = { "--edition 2023" },
          stdin = true,
        }
      end
    },

    c = {
      require("formatter.filetypes.cpp").clangformat,
    },
    cpp = {
      require("formatter.filetypes.cpp").clangformat,
    },
    fish = {
      require("formatter.filetypes.fish").fishindent,
    },
    latex = {
      require("formatter.filetypes.latex").latexindent,
    },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}


vim.api.nvim_create_augroup("formatter", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "formatter",
    command = "FormatWrite",
})