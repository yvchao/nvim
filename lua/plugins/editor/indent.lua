return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        enabled = false,
        show_start = true,
        show_end = false,
        injected_languages = false,
        highlight = { "Function", "Label" },
      },
      exclude = {
        filetypes = vim.g.special_buffer_list or {},
        buftypes = {
          "terminal",
        },
      },
    },
    event = "UIEnter",
  },
}
