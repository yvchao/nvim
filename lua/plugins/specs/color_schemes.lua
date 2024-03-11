return {
  -- dark purple color scheme
  {
    "rebelot/kanagawa.nvim",
    cond = function()
      return require("plugins.colors").theme == "kanagawa"
    end,
    lazy = false,
    priority = 1000,
    config = function()
      require("plugins.colors").kanagawa_setup()
    end,
  },

  -- GitHub light and dark colorscheme
  {
    "projekt0n/github-nvim-theme",
    cond = function()
      local select = require("plugins.colors").theme
      for _, avail in ipairs({
        "github_dark",
        "github_dimmed",
        "github_light",
        "github_light_default",
      }) do
        if select == avail then
          return true
        end
      end
      return false
    end,
    config = function()
      require("plugins.colors").github_setup()
    end,
  },

  -- dark blue and light yellow color scheme
  {
    "EdenEast/nightfox.nvim",
    cond = function()
      local select = require("plugins.colors").theme
      for _, avail in ipairs({ "nightfox", "dayfox", "dawnfox", "nordfox", "duskfox" }) do
        if select == avail then
          return true
        end
      end
      return false
    end,
    config = function()
      require("plugins.colors").nightfox_setup()
    end,
  },
}
