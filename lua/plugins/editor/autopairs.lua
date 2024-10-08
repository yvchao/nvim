return {
  {
    "windwp/nvim-autopairs",
    opts = {
      enable_check_bracket_line = false,
      check_ts = true,
      ts_config = {
        lua = { "string" }, -- it will not add pair on that treesitter node
      },
      disable_filetype = { "TelescopePrompt", "vim", "markdown", "quarto" },
    },
    event = "InsertEnter",
  },
}
