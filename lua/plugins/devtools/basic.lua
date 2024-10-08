return {
  -- manage the lsp server
  {
    "williamboman/mason.nvim",
    opts = {},
    event = { "FileType" },
  },

  -- {
  --   url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     -- require("lsp_lines").setup({ virtual_lines = { only_current_line = true } })
  --     require("lsp_lines").setup()
  --     vim.diagnostic.config({ virtual_lines = false })
  --   end,
  --   enabled = false,
  -- },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        quarto = { "injected" },
        tex = { "latexindent" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        rustfmt = {
          extra_args = { "--edition", "2021" },
        },
      },
      -- format_on_save = { timeout_ms = 600, lsp_fallback = true },
      format_after_save = { lsp_fallback = true },
    },
  },

  -- symbol list
  {
    "stevearc/aerial.nvim",
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    },
    cmd = "AerialOpen",
    event = "VeryLazy",
  },

  -- enhance the Cargo dependencies management
  {
    "saecki/crates.nvim",
    event = {
      "BufRead Cargo.toml",
    },
    opts = {
      popup = {
        autofocus = true,
        border = "single",
      },
    },
  },

  -- -- debugger plugin
  {
    "mfussenegger/nvim-dap",
    -- module = "dap",
    opts = {},
    cmd = { "DapBreakpoint" },
  },

  -- use `gcc` `gbc` to comment
  {
    "numToStr/Comment.nvim",
    opts = {},
    keys = {
      { "gcc", mode = "n" },
      { "gbc", mode = "n" },
      { "gc", mode = "v" },
      { "gb", mode = "v" },
    },
  },

  -- Doc string
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = { annotation_convention = "numpydoc" },
        },
        lua = {
          template = { annotation_convention = "emmylua" },
        },
      },
    },
    keys = {
      "<leader>doc",
      mode = "n",
    },
  },

  -- find definition, reference
  {
    "pechorin/any-jump.vim",
    init = function()
      vim.g.any_jump_window_width_ratio = 0.8
      vim.g.any_jump_window_height_ratio = 0.9
      vim.g.any_jump_disable_default_keybindings = 1
    end,
    cmd = {
      "AnyJump",
      "AnyJumpBack",
    },
  },

  -- run command in separate vim/nvim/tmux window
  {
    "tpope/vim-dispatch",
    cmd = "Dispatch",
  },

  -- add a progress bar for lsp server
  -- {
  --   "linrongbin16/lsp-progress.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("lsp-progress").setup()
  --   end,
  --   event = "LspAttach",
  --   enabled = false,
  -- },
  --

  {
    "abecodes/tabout.nvim",
    opts = {
      ignore_beginning = false,
      act_as_tab = true,
    },
    event = "InsertEnter",
  },

  {
    "benlubas/molten-nvim",
    ft = "quarto",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
    end,
    enabled = false,
  },

  {
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    enabled = false,
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        opts = {},
        ft = "quarto",
      },
      { "benlubas/molten-nvim" },
    },
    opts = {
      debug = false,
      lspFeatures = {
        enabled = true,
        languages = { "python", "bash", "julia", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "InsertLeave", "BufWritePost" },
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
      keymap = {
        hover = "gh",
        definition = "gd",
        type_definition = "gt",
        rename = "gr",
        format = "gf",
        references = "gR",
        document_symbols = "<leader>ls",
      },
    },
  },
}
