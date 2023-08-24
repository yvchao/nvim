return {
  -- deserialize code to generate text object for highlight and other enhancement
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins").load_cfg("treesitter_cfg")
    end,
    ft = vim.g.enable_treesitter_ft,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({enable = false,})
    end,
    ft = vim.g.enable_treesitter_ft,
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
    dependencies = { "airblade/vim-rooter", "williamboman/mason.nvim" },
  },

  {
    "williamboman/mason.nvim",
    ft = vim.g.enable_lspconfig_ft,
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
    -- after = "mason.nvim",
  },

  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("plugins").load_cfg("nullls_cfg")
    end,
    ft = { "python", "tex", "c", "cpp", "lua" },
  },

  -- Pre-set for rust lsp
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("plugins").load_cfg("rust_tools_cfg")
    end,
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

  {
    "barreiroleo/ltex-extra.nvim",
  },

  -- -- debugger plugin
  {
    "mfussenegger/nvim-dap",
    -- module = "dap",
    config = function()
      require("plugins").load_cfg("dap_cfg")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  -- generate quick jump list in side panel
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("plugins").load_cfg("symboloutline_cfg")
    end,
    cmd = "SymbolsOutline",
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
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function ()
      require('lsp-progress').setup()
    end
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
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-cmdline",
    },
    lazy = false,
    config = function()
      require("plugins").load_cfg("nvimcmp_cfg")
    end,
  },

  {
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup()
    end,
  },
}
