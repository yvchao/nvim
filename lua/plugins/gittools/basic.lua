return {
  -- A git tool like magit in Emacs
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Ggrep",
      "Gdiffsplit",
      "GBrowse",
      "Glog",
    },
  },

  -- Show git information in neovim
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "BufRead",
    opts = {
      signs = {
        add = {
          text = "▌",
        },
        change = {
          text = "▞",
        },
        delete = {
          text = "␡",
        },
        topdelete = {
          text = "‾",
        },
        changedelete = {
          text = "▒",
        },
      },
      numhl = true,
      linehl = false,
      watch_gitdir = { interval = 1000, follow_files = true },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "overlay", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      word_diff = false,
      -- diff_opts = { internal = true },
    },
  },

  -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- see configuration in
    -- https://github.com/sindrets/diffview.nvim#configuration
    opts = {},
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
  },

  -- Convert file containing conflict markers into a two-way diff
  {
    "whiteinge/diffconflicts",
    event = "VeryLazy",
  },

  -- Flog is a lightweight and powerful git branch viewer that integrates with fugitive.
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
}
