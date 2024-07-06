return {
  -- deserialize code to generate text object for highlight and other enhancement
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins").load_cfg("treesitter_cfg")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = "UIEnter",
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("treesitter-context").setup({ enable = false })
  --   end,
  --   enabled = false,
  -- },

  -- manage the lsp server
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins").load_cfg("lspconfig_cfg")
    end,
    dependencies = {
      "airblade/vim-rooter",
      "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim",
      -- "lsp_lines.nvim",
      -- "Issafalcon/lsp-overloads.nvim", -- TODO: replace this
      "hrsh7th/cmp-nvim-lsp",
    },
    ft = vim.g.enable_lspconfig_ft,
    lazy = true,
  },

  {
    "barreiroleo/ltex-extra.nvim",
    config = function()
      require("ltex_extra").setup({
        load_langs = { "en-US" },
        path = vim.fn.expand("~") .. "/.local/share/ltex",
      })
    end,
    ft = { "markdown", "tex" },
    lazy = true,
    enabled = false,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    cmd = { "Mason" },
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
    config = function()
      require("plugins").load_cfg("conform_cfg")
    end,
  },

  -- symbol list
  {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
    end,
    cmd = "AerialOpen",
    event = "VeryLazy",
  },

  -- enhance the Cargo dependencies management
  {
    "saecki/crates.nvim",
    event = {
      "BufRead Cargo.toml",
    },
    config = function()
      require("crates").setup({
        popup = {
          autofocus = true,
          border = "single",
        },
      })
    end,
  },

  -- -- debugger plugin
  {
    "mfussenegger/nvim-dap",
    -- module = "dap",
    config = function()
      require("plugins").load_cfg("dap_cfg")
    end,
    cmd = { "DapBreakpoint" },
  },

  -- use `gcc` `gbc` to comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
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
    config = function()
      require("plugins").load_cfg("neogen_cfg")
    end,
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
  {
    "linrongbin16/lsp-progress.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lsp-progress").setup()
    end,
    event = "LspAttach",
    enabled = false,
  },

  -- lot's of pre-set snippets
  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
    keys = {
      { ":", mode = "n" },
      { "/", mode = "n" },
    },
    ft = vim.g.enable_lspconfig_ft,
    enabled = false,
  },

  -- the completion core
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline",
      -- "kdheepak/cmp-latex-symbols",
    },
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    config = function()
      require("plugins").load_cfg("nvimcmp_cfg")
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = {
      -- "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
  },

  {
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        ignore_beginning = false,
        act_as_tab = true,
      })
    end,
    enabled = true,
    event = "InsertEnter",
  },

  {
    "github/copilot.vim",
    enabled = false,
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
  },

  {
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          { "neovim/nvim-lspconfig" },
        },
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
