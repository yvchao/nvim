local function setup_gitsigns()
  return {
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
    on_attach = function(bufnr)
      local function map(mode, lhs, rhs, opts)
        opts =
          vim.tbl_extend("force", { buffer = bufnr, noremap = true, silent = true }, opts or {})
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      map("n", "gij", function()
        local winnr = vim.fn.bufwinid(bufnr)
        if vim.api.nvim_get_option_value("diff", { win = winnr, scope = "local" }) then
          return "]c"
        else
          return "<cmd>Gitsigns next_hunk<CR>"
        end
      end, { expr = true })
      map("n", "gik", function()
        local winnr = vim.fn.bufwinid(bufnr)
        if vim.api.nvim_get_option_value("diff", { win = winnr, scope = "local" }) then
          return "[c"
        else
          return "<cmd>Gitsigns prev_hunk<CR>"
        end
      end, { expr = true })

      -- Actions
      map({ "n", "v" }, "gir", "<cmd>Gitsigns reset_hunk<CR>")
      map("n", "giR", "<cmd>Gitsigns reset_buffer<CR>")
      map("n", "gih", "<cmd>Gitsigns toggle_deleted<CR>")

      -- Text object
      map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<CR>")
    end,
  }
end

return {
  -- Show git information in neovim
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "BufRead",
    opts = function(_, options)
      return vim.tbl_extend("force", options or {}, setup_gitsigns())
    end,
  },
}
