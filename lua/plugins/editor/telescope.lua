local function setup_telescope()
  return {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix = "  ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      -- sorting_strategy = "descending",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = {},
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "absolute" },
      winblend = 0,
      border = true,
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },
    extensions = {
      ["ui-select"] = {},
    },
    pickers = {
      find_files = {
        theme = "ivy",
      },
      live_grep = {
        theme = "ivy",
      },
    },
  }
end

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "BufReadPost",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function(_, options)
      return vim.tbl_extend("force", options or {}, setup_telescope())
    end,
    keys = {
      {
        "<leader>ff",
        [[<cmd>lua require("telescope.builtin").find_files({ previewer = false })<CR>]],
        { desc = "find files" },
      },
      {
        "<leader>fg",
        [[<cmd>lua require("telescope.builtin").live_grep({})<CR>]],
        { desc = "live grep" },
      },
    },
    cmd = { "Telescope" },
    enabled = true,
  },
}
