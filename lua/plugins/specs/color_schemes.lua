return {
  -- dark purple color scheme
  {
    "rebelot/kanagawa.nvim",
    -- cond = function()
    --   return require("plugins.colors").theme == "kanagawa"
    -- end,
    lazy = false,
    -- priority = 1000,
    config = function()
      require("plugins.colors").kanagawa_setup()
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    -- cond = function()
    --   return require("plugins.colors").theme == "rose-pine"
    -- end,
    lazy = false,
    -- priority = 1000,
    config = function()
      require("plugins.colors").rosepine_setup()
    end,
  },
}
