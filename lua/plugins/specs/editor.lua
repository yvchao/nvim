return {

  -- adjust the shiftwidth and expandtab settings
  {
    "tpope/vim-sleuth",
    lazy = false,
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
  },

  -- list of nerdfont icons
  {
    "nvim-tree/nvim-web-devicons",
    event = "BufRead",
  },

  -- fancy status line
  {
    "nvimdev/galaxyline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
    config = function()
      require("plugins").load_cfg("galaxyline_cfg")
    end,
    enabled = false,
  },

  -- lua line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
    config = function()
      require("plugins").load_cfg("lualine_cfg")
    end,
  },

  -- buffer manager
  {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("plugins").load_cfg("bufferline_cfg")
    end,
    event = "BufRead",
    enabled = false,
  },

  -- float statusline
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup({
        hide = {
          focused_win = false,
          only_win = true,
          cursorline = true,
        },
        ignore = {
          filetypes = {
            "alpha",
            "oil",
            "qf",
            "help",
            "man",
            "term",
          },
        },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local res = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
          if vim.api.nvim_buf_get_option(props.buf, "modified") then
            res = res .. " [+]"
          end
          local left = "▓▒░ "
          local right = " ░▒▓"
          res = left .. res .. right
          return res
        end,
        window = {
          padding = {
            left = 0,
            right = 0,
          },
          margin = {
            horizontal = 0,
            vertical = 1,
          },
        },
      })
    end,
    enabled = true,
  },

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
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*", -- Highlight all files, but customize some others.
        css = {
          rgb_fn = true,
        }, -- Enable parsing rgb(...) functions in css.
      })
    end,
    event = "BufRead",
    cmd = {
      "ColorizerToggle",
      -- this help generate color for no filetype file
      "ColorizerAttachToBuffer",
    },
  },

  -- editing with multiple cursor
  {
    "mg979/vim-visual-multi",
    event = "InsertEnter",
    config = function()
      vim.g.VM_maps = {
        ["I BS"] = "", -- disable backspace mapping to avoid conflit with autopair
      }
    end,
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

  -- a dashboard that useless but beautiful
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins").load_cfg("alpha_cfg")
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = false,
  },

  -- cd into the root directory
  {
    "airblade/vim-rooter",
    event = "BufReadPost",
  },

  -- telescope: extensible fuzzy file finder
  {
    "nvim-telescope/telescope.nvim",
    -- event = "BufReadPost",
    dependencies = {
      -- "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("plugins").load_cfg("telescope_cfg")
      require("telescope").load_extension("ui-select")
    end,
    -- module = "telescope",
  },

  -- record and manage your paste history
  {
    "AckslD/nvim-neoclip.lua",
    event = "TextYankPost",
    config = function()
      require("neoclip").setup()
      require("telescope").load_extension("neoclip")
    end,
  },

  -- surrounding select text with given signs
  {
    "tpope/vim-surround",
    event = "BufRead",
    config = function()
      local map = require("lib.keymap").map
      -- release the S key to the lightspeed
      map("x", "S", "<Plug>Lightspeed_S", {
        noremap = false,
      })
      -- and remap it to gs
      map("x", "gs", "<Plug>VSurround", {
        noremap = false,
      })
    end,
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
      require("leap").add_default_mappings()
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
    dependencies = { "nvim-cmp" },
  },

  -- split single line and join multiple lines, useful for closing bracket
  {
    "AndrewRadev/splitjoin.vim",
    keys = {
      { "gJ", mode = "n" },
      { "gS", mode = "n" },
    },
  },

  -- generate line for guiding indent
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("plugins").load_cfg("indent_cfg")
    end,
    event = "BufRead",
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

  -- scroll smoothly
  -- {
  --   "karb94/neoscroll.nvim",
  --   config = function()
  --     require("plugins").load_cfg("neoscroll_cfg")
  --   end,
  --   keys = { { "<C-e>" }, { "<C-y>" }, { "<C-f>" }, { "<C-b>" } },
  -- },

  -- search and replace with a panel
  -- {
  --   "windwp/nvim-spectre",
  --   requires = { "nvim-lua/plenary.nvim" },
  --   module = "spectre",
  -- },

  {
    "h-hg/fcitx.nvim",
  },

  -- file manager in buffer
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        columns = {
          "icon",
          "size",
        },
        delete_to_trash = true,
        win_options = {
          concealcursor = "nvci",
        },
      })
    end,
  },

  -- undo tree
  {
    "mbbill/undotree",
  },

  -- session manager
  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~", "~/Projects", "~/Downloads", "/" },
      })
      require("telescope").load_extension("session-lens")
    end,
  },
}
