-- theme
local vim_theme = "rose-pine"

local ok, custom = pcall(require, "custom")
-- if file exist, return table exist and return table has `theme` field
if ok and custom and custom.theme then
  vim_theme = custom.theme
end

-- This functions finally apply the colorscheme
local function apply()
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal", bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { bold = true })

  local opts = { bg = "none" }
  vim.api.nvim_set_hl(0, "FloatBorder", opts)
  vim.api.nvim_set_hl(0, "FloatTitle", opts)
  -- opts = vim.api.nvim_get_hl(0, { name = "Visual" })
  -- opts.reverse = true
  -- vim.api.nvim_set_hl(0, "Visual", opts)
  --
  vim.cmd("colorscheme " .. vim_theme)
end

-- configure the kanagawa theme
local function kanagawa_setup()
  vim.o.background = "dark"
  require("kanagawa").setup({
    functionStyle = { bold = true },
    typeStyle = { bold = true },
    transparent = false, -- do not set background color
    dimInactive = true,
    theme = "wave",
    background = {
      dark = "wave",
      light = "lotus",
    },
    overrides = function(colors)
      local palette = colors.palette
      local theme = colors.theme
      return {
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        HighLightLineMatches = {
          bg = palette.winterYellow,
        },
        WinSeparator = { fg = palette.lightBlue },
        TelescopeTitle = { fg = theme.ui.special, bold = true },
        TelescopePreviewTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        TelescopePromptTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        TelescopeResultsTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        InclineNormal = { fg = palette.sumiInk1, bg = palette.waveRed },
        InclineNormalNC = { fg = palette.winterBlue, bg = palette.sakuraPink },
        ["@comment.todo"] = { link = "@text.todo" },
      }
    end,
  })
  apply()
end

-- configure the rosepine theme
local function rosepine_setup()
  vim.o.background = "dark"
  require("rose-pine").setup({
    highlight_groups = {
      TelescopeBorder = { fg = "overlay", bg = "overlay" },
      TelescopeNormal = { fg = "subtle", bg = "overlay" },
      TelescopeSelection = { fg = "text", bg = "highlight_med" },
      TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
      TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

      TelescopeTitle = { fg = "base", bg = "love" },
      TelescopePromptTitle = { fg = "base", bg = "pine" },
      TelescopePreviewTitle = { fg = "base", bg = "iris" },

      TelescopePromptNormal = { fg = "text", bg = "surface" },
      TelescopePromptBorder = { fg = "surface", bg = "surface" },
    },
  })
  apply()
end

return {
  -- dark purple color scheme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    -- priority = 1000,
    config = kanagawa_setup,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    -- priority = 1000,
    config = rosepine_setup,
  },
}
