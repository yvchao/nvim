return {
  -- adjust the shiftwidth and expandtab settings
  {
    "tpope/vim-sleuth",
    event = "BufRead",
  },

  -- markdown editing enhancement
  -- TODO: delete this plugin
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
    opts = {},
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = false,
        wrap = true,
      },
    },
  },

  -- list of nerdfont icons
  {
    "nvim-tree/nvim-web-devicons",
    event = "BufRead",
  },

  -- visualize hex/rgb code
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = {
        -- "*", -- Highlight all files, but customize some others.
        "!vim", -- Exclude vim from highlighting.
        "tex",
        css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
        html = { names = false }, -- Disable parsing "names" like Blue or Gray
      },
    },
    event = "BufRead",
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
    },
  },

  -- Linux coreutil in vim
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

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      fzf_colors = {
        ["gutter"] = { "bg", "Normal" },
      },
    },
    keys = {
      { "<leader>f", mode = "n" },
    },
    cmd = { "FzfLua" },
    enabled = false,
  },

  {
    "junegunn/fzf",
    build = "./install --bin",
    cmd = { "FZF" },
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
    init = function()
      -- require("leap").create_default_mappings()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
    end,
    event = "UIEnter",
  },

  -- Enhanced the `%` keymap
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
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
    opts = {},
    cmd = "Sort",
  },

  -- disable slow plugins for bigfiles
  {
    "LunarVim/bigfile.nvim",
    event = "BufRead",
  },

  {
    "stevearc/oil.nvim",
    opts = {},
  },

  -- undo tree
  {
    "mbbill/undotree",
    event = "UIEnter",
  },

  -- smart buffer in tabs
  {
    "tiagovla/scope.nvim",
    opts = {},
    event = "BufRead",
  },
}
