-- [[
-- Components:
--   autoload,          (This plugins will always be sources)
--   markdown_plugins,  (markdown plugins)
--   git_tools,         (git plugins)
--   editor_enhance,    (plugins to enhance neovim)
--   colorscheme,       (colorscheme plugins)
--   completion,        (nvim-cmp and its plugins)
--   coding_enhance,    (plugins for coding)
-- ]]

local autoload = {
  -- speed up neovim!
  -- {
  --   "nathom/filetype.nvim",
  --   config = function()
  --     require("filetype").setup({
  --       -- overrides the filetype or function for filetype
  --       -- See https://github.com/nathom/filetype.nvim#customization
  --       overrides = {},
  --     })
  --   end,
  -- },

  -- adjust the shiftwidth and expandtab settings
  {
    "tpope/vim-sleuth",
  },

  -- Fix the CursorHold performance bug
  -- {
  --   "antoinemadec/FixCursorHold.nvim",
  -- },

  -- cache everything!
  {
    "lewis6991/impatient.nvim",
  },
}

-- local markdown_plugins = {
--   -- markdown toc
--   {
--     "mzlogin/vim-markdown-toc",
--     cmd = {
--       "GenTocGFM",
--     },
--   },
--
-- markdown preview
-- {
--   "iamcco/markdown-preview.nvim",
--   run = function()
--     vim.fn["mkdp#util#install"]()
--   end,
--   config = function()
--     require("plugins").load_cfg("markdown_preview_cfg")
--   end,
--   ft = {
--     "markdown",
--   },
-- },
--
-- markdown editing enhancement
--   {
--     "plasticboy/vim-markdown",
--     ft = {
--       "markdown",
--     },
--   },
--
--   -- table editing enhancement
--   {
--     "dhruvasagar/vim-table-mode",
--     cmd = "TableModeToggle",
--   },
-- }
--

local git_tools = {
  -- A git tool like magit in Emacs
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Ggrep",
      "Gdiffsplit",
      "GBrowse",
    },
  },

  -- Call the lazygit inside neovim, relies on lazygit executable
  -- {
  --   "kdheepak/lazygit.nvim",
  --   setup = function()
  --     vim.g.lazygit_floating_window_winblend = 0
  --     vim.g.lazygit_floating_window_scaling_factor = 1
  --     vim.g.lazygit_floating_window_corner_chars = {
  --       "╭",
  --       "╮",
  --       "╰",
  --       "╯",
  --     }
  --     vim.g.lazygit_floating_window_use_plenary = 0
  --     vim.g.lazygit_use_neovim_remote = 1
  --     if vim.g.lazygit_use_neovim_remote == 1 and vim.fn.executable("nvr") then
  --       vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  --     end
  --   end,
  --   cmd = "LazyGit",
  -- },

  -- Show git information in neovim
  {
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    event = "BufRead",
    config = function()
      require("plugins").load_cfg("gitsign_cfg")
    end,
  },

  -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
  {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup({
        -- see configuration in
        -- https://github.com/sindrets/diffview.nvim#configuration
      })
    end,
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
  },

  -- Flog is a lightweight and powerful git branch viewer that integrates with fugitive.
  {
    "rbong/vim-flog",
    -- run command after the vim fugitive
    cmd = {
      "Flog",
      "Flogsplit",
    },
  },
}

local editor_enhance = {
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
    "kyazdani42/nvim-web-devicons",
    event = "BufRead",
  },

  -- fancy status line
  {
    "Avimitin/galaxyline.nvim",
    branch = "main",
    after = "nvim-web-devicons",
    config = function()
      require("plugins").load_cfg("galaxyline_cfg")
    end,
  },

  -- buffer manager
  {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("plugins").load_cfg("bufferline_cfg")
    end,
    event = "BufRead",
  },

  -- tree style file manager
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("plugins").load_cfg("nvimtree_cfg")
    end,
    cmd = {
      "NvimTreeRefresh",
      "NvimTreeToggle",
    },
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
    branch = "master",
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
  -- {
  --   "glepnir/dashboard-nvim",
  --   cmd = {
  --     "Dashboard",
  --   },
  --   config = function()
  --     require("plugins").load_cfg("dashboard_cfg")
  --   end,
  -- },
  {
    "goolord/alpha-nvim",
    config = function ()
      require("plugins").load_cfg("alpha_cfg")
    end,
    -- after = "telescope",
  },

  -- cd into the root directory
  {
    "airblade/vim-rooter",
    event = "BufReadPost",
    config = function()
      vim.cmd("Rooter")
    end,
  },

  -- telescope: extensible fuzzy file finder
  {
    "nvim-telescope/telescope.nvim",
    -- event = "BufReadPost",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins").load_cfg("telescope_cfg")
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

  -- Press enter to select text object
  -- {
  --   "gcmt/wildfire.vim",
  --   keys = {
  --     {
  --       "n",
  --       "<Enter>",
  --     },
  --   },
  --   ft = vim.g.enable_treesitter_ft,
  -- },

  -- surrounding select text with given signs
  {
    "tpope/vim-surround",
    event = "BufRead",
    config = function()
      local map = require("mappings.utils").map
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
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },

  -- a swiss knife for aligning text
  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
  },

  -- Move cursor by text search
  {
    "ggandor/lightspeed.nvim",
    keys = {
      { "n", "s" },
      { "v", "s" },
      { "n", "S" },
      { "v", "S" },
      { "n", "f" },
      { "n", "F" },
      { "n", "t" },
      { "n", "T" },
      { "v", "f" },
      { "v", "F" },
      { "v", "t" },
      { "v", "T" },
    },
  },

  -- Enhanced the `%` keymap
  {
    "andymass/vim-matchup",
    keys = {
      { "n", "%" },
      { "v", "%" },
    },
  },

  -- automatically pairs the bracket
  {
    "windwp/nvim-autopairs",
    config = function()
      require("plugins").load_cfg("autopairs_cfg")
    end,
    after = "nvim-cmp",
  },

  -- Lua
  {
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
    wants = { "nvim-treesitter" }, -- or require if not used so far
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
  },

  -- file manager without any dependency
  -- {
  --   "obaland/vfiler.vim",
  --   cmd = "VFiler",
  --   requires = {
  --     "obaland/vfiler-column-devicons",
  --   },
  --   config = function()
  --     require("vfiler/config").setup({
  --       options = {
  --         columns = "indent,devicons,name,mode,size,time",
  --       },
  --     })
  --   end,
  -- },

  -- split single line and join multiple lines, useful for closing bracket
  {
    "AndrewRadev/splitjoin.vim",
    keys = {
      { "n", "gJ" },
      { "n", "gS" },
    },
  },

  -- generate line for guiding indent
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins").load_cfg("indent_cfg")
    end,
    event = "BufRead",
  },

  -- repeat your last action, what ever command or keymaps or inputs
  {
    "tpope/vim-repeat",
    keys = {
      { "n", "." },
    },
  },

  -- a curl wrapper in neovim
  {
    "NTBBloodbath/rest.nvim",
    requires = {
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
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("plugins").load_cfg("neoscroll_cfg")
    end,
    keys = { { "n", "<C-e>" }, { "n", "<C-y>" }, { "n", "<C-f>" }, { "n", "<C-b>" } },
  },

  -- search and replace with a panel
  {
    "windwp/nvim-spectre",
    requires = { "nvim-lua/plenary.nvim" },
    module = "spectre",
  },

  -- {
  --   "gelguy/wilder.nvim",
  --   config = function()
  --     require("wilder").setup({ modes = { ":", "/", "?" } })
  --   end,
  -- },

  -- {
  --   "beauwilliams/focus.nvim",
  --   event = "WinEnter",
  --   config = function()
  --     require("focus").setup({
  --       excluded_filetypes = { "fterm", "term", "toggleterm" },
  --       signcolumn = false,
  --     })
  --   end,
  -- },

  -- {
  --   "stevearc/dressing.nvim",
  --   module = "vim.ui",
  --   config = function()
  --     require("dressing").setup({})
  --   end,
  -- },

  -- add notify window
  -- {
  --   "rcarriga/nvim-notify",
  --   module = "vim",
  --   config = function()
  --     require("notify").setup({
  --       render = "compact",
  --       stages = "static",
  --       max_height = 20,
  --       max_width = 200,
  --     })
  --     vim.notify = require("notify")
  --     require("telescope").load_extension("notify")
  --   end,
  -- },
}

local colorscheme = {
  -- dark green color scheme
  {
    "Avimitin/neovim-deus",
    cond = function()
      return require("core.colors").theme == "deus"
    end,
    config = function()
      require("core.colors").deus_setup()
    end,
  },

  -- dark purple color scheme
  {
    "rebelot/kanagawa.nvim",
    cond = function()
      return require("core.colors").theme == "kanagawa"
    end,
    config = function()
      require("core.colors").kanagawa_setup()
    end,
  },

  -- GitHub light and dark colorscheme
  {
    "projekt0n/github-nvim-theme",
    cond = function()
      local select = require("core.colors").theme
      for _, avail in ipairs({
        "github_dark",
        "github_dimmed",
        "github_light",
        "github_light_default",
      }) do
        if select == avail then
          return true
        end
      end
      return false
    end,
    config = function()
      require("core.colors").github_setup()
    end,
  },

  -- dark blue and light yellow color scheme
  {
    "EdenEast/nightfox.nvim",
    cond = function()
      local select = require("core.colors").theme
      for _, avail in ipairs({ "nightfox", "dayfox", "dawnfox", "nordfox", "duskfox" }) do
        if select == avail then
          return true
        end
      end
      return false
    end,
    config = function()
      require("core.colors").nightfox_setup()
    end,
  },
}

local coding_enhance = {
  -- deserialize code to generate text object for highlight and other enhancement
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("plugins").load_cfg("treesitter_cfg")
    end,
    ft = vim.g.enable_treesitter_ft,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    after = "nvim-treesitter",
    config = function()
      require("treesitter-context").setup()
    end,
  },

  {
    "h-hg/fcitx.nvim",
  },
  -- -- automatically download and manage lsp server
  -- {
  --   "williamboman/nvim-lsp-installer",
  --   ft = vim.g.enable_lspconfig_ft,
  --   config = function()
  --     require("lspconfig")
  --   end,
  -- },

  {
    "williamboman/mason.nvim",
    ft = vim.g.enable_lspconfig_ft,
    config = function()
      require("lspconfig")
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
  },

  -- manage the lsp server
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins").load_cfg("lspconfig_cfg")
    end,
    module = "lspconfig",
    after = "vim-rooter",
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },

  -- enhance the lsp UI
  {
    "kkharji/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("plugins").load_cfg("lspsaga_cfg")
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
    requires = {
      {
        "nvim-lua/plenary.nvim",
      },
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
    module = "dap",
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
  --
  -- -- UI for nvim-dap
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   module = "dapui",
  -- },

  -- generate quick jump list in side panel
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("plugins").load_cfg("symboloutline_cfg")
    end,
    cmd = "SymbolsOutline",
  },

  -- go coding enhancement
  -- {
  --   "fatih/vim-go",
  --   config = function()
  --     require("plugins").load_cfg("vim_go_cfg")
  --   end,
  --   ft = { "go" },
  -- },

  -- format code use clang-format
  -- {
  --   "mhartington/formatter.nvim",
  --   config = function ()
  --     require("plugins").load_cfg("formatter_cfg")
  --   end,
  --   ft = {
  --     "cpp",
  --     "c",
  --     "h",
  --     "hpp",
  --     "python",
  --   },
  -- },

  -- use `gcc` `gbc` to comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
    keys = {
      { "n", "gcc" },
      { "n", "gbc" },
      { "v", "gc" },
      { "v", "gb" },
    },
  },

  -- Doc string
  {
    "danymat/neogen",
    config = function()
      require("plugins").load_cfg("neogen_cfg")
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },

  -- find definition, reference
  {
    "pechorin/any-jump.vim",
    setup = function()
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
    "j-hui/fidget.nvim",
    tag = "legacy",
    after = "nvim-lspconfig",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        fmt = {
          stack_upwards = true,
        },
        sources = {
          ltex = {
            ignore = true,
          },
        },
      })
    end,
  },
}

local completion = {
  -- lot's of pre-set snippets
  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
    keys = {
      { "n", ":" },
      { "n", "/" },
    },
  },

  -- the completion core
  {
    "hrsh7th/nvim-cmp",
    after = "friendly-snippets",
    config = function()
      require("plugins").load_cfg("nvimcmp_cfg")
    end,
  },

  -- completion source for system path
  {
    "hrsh7th/cmp-path",
    after = {
      "nvim-cmp",
    },
  },

  -- completion source for lspconfig
  {
    "hrsh7th/cmp-nvim-lsp",
    after = {
      "nvim-cmp",
    },
  },

  -- completion source for word in current buffer
  {
    "hrsh7th/cmp-buffer",
    after = {
      "nvim-cmp",
    },
  },

  -- completion source for vsnip snippet plugin
  {
    "hrsh7th/cmp-vsnip",
    after = {
      "nvim-cmp",
    },
  },

  -- the snippet core
  {
    "hrsh7th/vim-vsnip",
    after = {
      "nvim-cmp",
    },
  },

  {
    "hrsh7th/cmp-cmdline",
    after = {
      "nvim-cmp",
    },
  },

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   config = function ()
  --     require("plugins").load_cfg("lsp_signature_cfg")
  --   end,
  --   ft = vim.g.enable_lspconfig_ft,
  -- },

  -- {
  --   "uga-rosa/cmp-dictionary",
  --   after = "nvim-cmp",
  --   config = function()
  --     require("cmp_dictionary").setup({
  --       exact = 2,
  --       first_case_insensitive = true,
  --       document = false,
  --     })
  --     require("cmp_dictionary").switcher({
  --       spelllang = {
  --         en = "~/.local/share/dict/en.dict",
  --       },
  --     })
  --     -- require("cmp_dictionary").update() -- THIS
  --   end,
  -- },
}

return {
  autoload,
  git_tools,
  editor_enhance,
  colorscheme,
  completion,
  coding_enhance,
}
