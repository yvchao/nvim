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
