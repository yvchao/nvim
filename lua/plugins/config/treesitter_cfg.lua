require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "vim",
    "make",
    "c",
    "comment",
    "cpp",
    "go",
    "javascript",
    "json",
    "rust",
    "toml",
    "python",
    "markdown",
    "julia",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  matchup = {
    enable = true,
  },
  incremental_selection = {
    enable = false, -- this may cause crashes
    keymaps = {
      init_selection = true,
      node_incremental = "v",
      node_decremental = "<BS>",
    },
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]a"] = "@parameter.inner",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[a"] = "@parameter.inner",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})
