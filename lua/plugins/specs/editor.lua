return {

  -- adjust the shiftwidth and expandtab settings
  {
    "tpope/vim-sleuth",
    event = "BufRead",
  },

  -- markdown editing enhancement
  {
    "plasticboy/vim-markdown",
    dependencies = {
      "godlygeek/tabular", -- markdown table
    },
    ft = {
      "markdown",
      "quarto",
    },
  },

  {
    "sindrets/winshift.nvim",
    cmd = {
      "WinShift",
    },
    config = function()
      require("winshift").setup({})
    end,
  },

  {
    "ojroques/nvim-bufdel",
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = false,
      },
    },
  },

  -- list of nerdfont icons
  {
    "nvim-tree/nvim-web-devicons",
    event = "BufRead",
  },

  -- lua line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- lualine optimization
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    config = function()
      require("plugins").load_cfg("lualine_cfg")
    end,
    event = "UIEnter",
  },

  -- float statusline
  {
    "b0o/incline.nvim",
    config = function()
      require("plugins").load_cfg("incline_cfg")
    end,
    enabled = false,
    event = "UIEnter",
  },

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("plugins").load_cfg("toggleterm_cfg")
    end,
    cmd = "ToggleTerm",
    branch = "main",
  },

  -- generate color from hex/rgb code
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = {
          -- "*", -- Highlight all files, but customize some others.
          "!vim", -- Exclude vim from highlighting.
          "tex",
          css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
          html = { names = false }, -- Disable parsing "names" like Blue or Gray
        },
      })
    end,
    event = "BufRead",
    cmd = {
      "ColorizerToggle",
      -- this help generate color for no filetype file
      "ColorizerAttachToBuffer",
    },
  },

  -- Linux coreutil in vim
  {
    "tpope/vim-eunuch",
    cmd = {
      -- Sudo needs you to configured the /etc/sudo.conf file to set the
      -- correct askpass executable.
      "SudoWrite",
      "SudoEdit",
      "Delete",
      "Unlink",
      "Move",
      "Rename",
      "Chmod",
      "Mkdir",
    },
    enabled = false,
  },

  {
    "lambdalisue/suda.vim",
    cmd = {
      "SudaRead",
      "SudaWrite",
    },
    init = function()
      vim.g.suda_smart_edit = 0 -- avoid creating virtual files
    end,
    event = "BufReadPre",
  },

  -- cd into the root directory
  {
    "airblade/vim-rooter",
    event = "BufReadPost",
  },

  -- telescope: extensible fuzzy file finder
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   event = "BufReadPost",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("plugins").load_cfg("telescope_cfg")
  --   end,
  --   keys = {
  --     { "<leader>f", mode = "n" },
  --   },
  --   cmd = { "Telescope" },
  --   enabled = false,
  -- },

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- "junegunn/fzf",
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        fzf_colors = {
          ["gutter"] = { "bg", "Normal" },
        },
      })
    end,
    keys = {
      { "<leader>f", mode = "n" },
    },
    cmd = { "FzfLua" },
    enabled = true,
  },

  {
    "junegunn/fzf",
    build = "./install --bin",
    cmd = { "FZF" },
    enabled = function()
      return vim.fn.executable("fzf") ~= 1
    end,
  },

  -- surrounding select text with given signs
  {
    "tpope/vim-surround",
    event = "UIEnter",
  },

  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      triggers_blacklist = {
        n = { ">", "<" },
        v = { ">", "<" },
      },
    },
    event = "UIEnter",
    enabled = false,
  },

  -- a swiss knife for aligning text
  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
  },

  -- Move cursor by text search
  {
    "ggandor/leap.nvim",
    config = function()
      -- require("leap").create_default_mappings()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
    end,
    keys = {
      { "s", mode = "n" },
      { "s", mode = "v" },
      { "S", mode = "n" },
      { "S", mode = "v" },
    },
  },

  -- Enhanced the `%` keymap
  {
    "andymass/vim-matchup",
    keys = {
      { "%", mode = "n" },
      { "%", mode = "v" },
    },
  },

  -- automatically pairs the bracket
  {
    "windwp/nvim-autopairs",
    config = function()
      require("plugins").load_cfg("autopairs_cfg")
    end,
    event = "InsertEnter",
  },

  -- generate line for guiding indent
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("plugins").load_cfg("indent_cfg")
    end,
    event = "UIEnter",
  },

  -- repeat your last action, what ever command or keymaps or inputs
  {
    "tpope/vim-repeat",
    keys = {
      { ".", mode = "n" },
    },
  },

  -- sort the number or text
  {
    "sQVe/sort.nvim",
    config = function()
      require("sort").setup({})
    end,
    cmd = "Sort",
  },

  -- disable slow plugins for bigfiles
  {
    "LunarVim/bigfile.nvim",
    event = "BufRead",
  },

  -- {
  --   "h-hg/fcitx.nvim",
  --   event = "VeryLazy",
  -- },

  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.starter").setup()
      -- require("mini.files").setup()
      require("mini.sessions").setup()
      require("mini.pick").setup()
      require("mini.splitjoin").setup()
      vim.ui.select = require("mini.pick").ui_select
    end,
  },

  {
    "stevearc/oil.nvim",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({})
    end,
  },

  -- undo tree
  {
    "mbbill/undotree",
    event = "UIEnter",
  },

  -- smart buffer in tabs
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup({})
    end,
    event = "BufRead",
  },
}
