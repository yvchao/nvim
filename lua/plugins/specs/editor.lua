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
    -- keys = { ";q", mode = "n" },
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- list of nerdfont icons
  {
    "nvim-tree/nvim-web-devicons",
    event = "BufRead",
  },

  -- fancy status line
  -- {
  --   "nvimdev/galaxyline.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
  --   config = function()
  --     require("plugins").load_cfg("galaxyline_cfg")
  --   end,
  --   enabled = false,
  -- },

  -- lua line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins").load_cfg("lualine_cfg")
    end,
    event = "UIEnter",
  },

  -- buffer manager
  -- {
  --   "akinsho/nvim-bufferline.lua",
  --   config = function()
  --     require("plugins").load_cfg("bufferline_cfg")
  --   end,
  --   event = "BufRead",
  --   enabled = false,
  -- },

  -- float statusline
  -- {
  --   "b0o/incline.nvim",
  --   config = function()
  --     require("incline").setup({
  --       hide = {
  --         focused_win = false,
  --         only_win = true,
  --         cursorline = true,
  --       },
  --       ignore = {
  --         filetypes = {
  --           "alpha",
  --           "oil",
  --           "qf",
  --           "help",
  --           "man",
  --           "term",
  --         },
  --       },
  --       render = function(props)
  --         local bufname = vim.api.nvim_buf_get_name(props.buf)
  --         local res = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
  --         if vim.api.nvim_buf_get_option(props.buf, "modified") then
  --           res = res .. " [+]"
  --         end
  --         local left = "▓▒░ "
  --         local right = " ░▒▓"
  --         res = left .. res .. right
  --         return res
  --       end,
  --       window = {
  --         padding = {
  --           left = 0,
  --           right = 0,
  --         },
  --         margin = {
  --           horizontal = 0,
  --           vertical = 1,
  --         },
  --       },
  --     })
  --   end,
  --   enabled = false,
  -- },
  --
  -- tree style file manager
  -- {
  --   "kyazdani42/nvim-tree.lua",
  --   config = function()
  --     require("plugins").load_cfg("nvimtree_cfg")
  --   end,
  --   cmd = {
  --     "NvimTreeRefresh",
  --     "NvimTreeToggle",
  --   },
  -- },

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
  },

  -- cd into the root directory
  {
    "airblade/vim-rooter",
    event = "BufReadPost",
  },

  -- telescope: extensible fuzzy file finder
  {
    "nvim-telescope/telescope.nvim",
    event = "BufReadPost",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins").load_cfg("telescope_cfg")
      -- require("telescope").load_extension("ui-select")
    end,
    enabled = false,
  },

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "junegunn/fzf",
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
    keys = {
      { "<leader>f", mode = "n" },
    },
  },

  {
    "junegunn/fzf",
    build = "./install --bin",
    event = "UIEnter",
  },

  -- surrounding select text with given signs
  {
    "tpope/vim-surround",
    event = "BufRead",
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
      vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>(leap-backward)")
    end,
    keys = {
      { "f", mode = "n" },
      { "f", mode = "v" },
      { "F", mode = "n" },
      { "F", mode = "v" },
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

  -- split single line and join multiple lines, useful for closing bracket
  -- {
  --   "AndrewRadev/splitjoin.vim",
  --   keys = {
  --     { "gJ", mode = "n" },
  --     { "gS", mode = "n" },
  --   },
  -- },

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

  -- a curl wrapper in neovim
  {
    "NTBBloodbath/rest.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins").load_cfg("rest_nvim_cfg")
    end,
    ft = "http",
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

  {
    "h-hg/fcitx.nvim",
    event = "VeryLazy",
  },

  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.starter").setup()
      require("mini.files").setup()
      require("mini.sessions").setup()
      require("mini.pick").setup()
      require("mini.splitjoin").setup()
      vim.ui.select = require("mini.pick").ui_select
    end,
  },

  -- undo tree
  {
    "mbbill/undotree",
    event = "BufReadPost",
  },

  -- remote clipboard with osc52
  {
    "ojroques/nvim-osc52",
    event = "UIEnter",
    enabled = false,
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
