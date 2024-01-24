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
    ft = vim.g.enable_treesitter_ft,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("treesitter-context").setup({ enable = false })
    end,
    enabled = false,
  },

  {
    "h-hg/fcitx.nvim",
  },

  -- manage the lsp server
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins").load_cfg("lspconfig_cfg")
    end,
    -- module = "lspconfig",
    dependencies = {
      "airblade/vim-rooter",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "barreiroleo/ltex-extra.nvim",
      "lsp_lines.nvim",
      "Issafalcon/lsp-overloads.nvim",
    },
    ft = vim.g.enable_lspconfig_ft,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      -- require("lsp_lines").setup({ virtual_lines = { only_current_line = true } })
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = false })
    end,
    enabled = false,
  },

  {
    "VidocqH/lsp-lens.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lsp-lens").setup({
        enable = false,
      })
    end,
    enabled = false,
  },

  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   config = function()
  --     require("plugins").load_cfg("nullls_cfg")
  --   end,
  --   ft = { "python", "tex", "c", "cpp", "lua" },
  -- },

  {
    "mhartington/formatter.nvim",
    config = function()
      require("plugins").load_cfg("formatter_cfg")
    end,
    enabled = false,
  },

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
  },

  -- Pre-set for rust lsp
  -- {
  --   "simrat39/rust-tools.nvim",
  --   ft = "rust",
  --   config = function()
  --     require("plugins").load_cfg("rust_tools_cfg")
  --   end,
  -- },

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
  },

  -- {
  --   "theHamsta/nvim-dap-virtual-text",
  --   config = function()
  --     require("nvim-dap-virtual-text").setup()
  --   end,
  -- },

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
    -- requires = "nvim-treesitter/nvim-treesitter",
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
  },

  -- lot's of pre-set snippets
  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
    keys = {
      { ":", mode = "n" },
      { "/", mode = "n" },
    },
  },

  -- the completion core
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      -- "hrsh7th/cmp-vsnip",
      -- "hrsh7th/vim-vsnip",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline",
      "kdheepak/cmp-latex-symbols",
    },
    lazy = false,
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
      "rafamadriz/friendly-snippets",
    },
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
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          python = true,
          c = true,
          cpp = true,
          ["*"] = false,
        },
      })
    end,
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
