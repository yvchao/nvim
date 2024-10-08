return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.starter").setup()
      require("mini.sessions").setup()
      require("mini.pick").setup()
      require("mini.splitjoin").setup()
      vim.ui.select = require("mini.pick").ui_select
    end,
  },
}
