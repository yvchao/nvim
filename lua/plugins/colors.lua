-- theme

local M = {
  -- "kanagawa" by default
  -- Available theme value:
  --  "kanagawa", "night","dawn","day","nord","dusk"+"fox"
  theme = "kanagawa",
}

local ok, custom = pcall(require, "custom")
-- if file exist, return table exist and return table has `theme` field
if ok and custom and custom.theme then
  M.theme = custom.theme
end

-- This functions finally apply the colorscheme
local function apply()
  vim.cmd("colorscheme " .. M.theme)

  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal", bg = "none" })
  local opts = {}
  opts = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
  opts.bg = "none"
  vim.api.nvim_set_hl(0, "FloatBorder", opts)
  opts = vim.api.nvim_get_hl(0, { name = "FloatTitle" })
  opts.bg = "none"
  vim.api.nvim_set_hl(0, "FloatTitle", opts)
  -- opts = vim.api.nvim_get_hl(0, { name = "Visual" })
  -- opts.reverse = true
  -- vim.api.nvim_set_hl(0, "Visual", opts)
end

-- configure the kanagawa theme
M.kanagawa_setup = function()
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
        -- TelescopeTitle = { fg = theme.ui.special, bold = true },
        -- TelescopePreviewTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        -- TelescopePromptTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        -- TelescopeResultsTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        InclineNormal = { fg = palette.sumiInk1, bg = palette.waveRed },
        InclineNormalNC = { fg = palette.winterBlue, bg = palette.sakuraPink },
        ["@comment.todo"] = { link = "@text.todo" },
      }
    end,
  })
  apply()
end

-- configure the nightfox theme
M.nightfox_setup = function()
  require("nightfox").setup()
  apply()
end

-- configure the nightfox theme
M.github_setup = function()
  -- trim the prefix text
  require("github-theme").setup({})
  -- this plugin will setup colorscheme for us
  apply()
end

-- return the configuration for load condition
return M
