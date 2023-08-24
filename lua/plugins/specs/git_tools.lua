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
    },
  },

  -- Show git information in neovim
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
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
    dependencies = {"nvim-lua/plenary.nvim"},
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
