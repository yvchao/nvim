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
      -- "ray-x/lsp_signature.nvim",
      "barreiroleo/ltex-extra.nvim",
      "lsp_lines.nvim",
    },
    ft = vim.g.enable_lspconfig_ft,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   config = function()
  --     require("mason-lspconfig").setup()
  --   end,
  --   -- after = "mason.nvim",
  -- },

  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
    end,
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

  -- alternative signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
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

  -- {
  --   "barreiroleo/ltex-extra.nvim",
  -- },

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
        ignore_beginning = true,
        act_as_tab = true,
      })
    end,
  },

  {
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_target = "neovim"
      vim.g.slime_no_mappings = 1
      vim.g.slime_python_ipython = 1
      vim.g.slime_paste_file = vim.env.HOME .. "/.cache/slime_paste"
      vim.b["quarto_is_" .. "python" .. "_chunk"] = false
      Quarto_is_in_python_chunk = function()
        require("otter.tools.functions").is_otter_language_context("python")
      end

      vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      return a:text
      end
      endfunction
      ]])
    end,
    ft = { "python", "quarto", "julia" },
  },

  {
    "quarto-dev/quarto-nvim",
    dev = false,
    ft = "quarto",
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dev = false,
        dependencies = {
          { "neovim/nvim-lspconfig" },
        },
        opts = {},
        ft = "quarto",
      },
    },
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { "python", "bash", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "InsertLeave" },
        },
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
