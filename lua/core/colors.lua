-- theme
vim.opt.termguicolors = true
vim.opt.background = "dark"

local M = {
  -- "kanagawa" by default
  -- Available theme value:
  --  "kanagawa", "deus", "night","dawn","day","nord","dusk"+"fox"
  theme = "kanagawa",
}

-- Try to update the theme value if the lua/custom.lua file exist.
-- User should return their custom value in the below form:
--
-- ```lua
-- local M = {
--     theme = "deus",
-- }
--
-- return M
-- ```

local ok, custom = pcall(require, "custom")
-- if file exist, return table exist and return table has `theme` field
if ok and custom and custom.theme then
  M.theme = custom.theme
end

-- This functions finally apply the colorscheme
local function apply()
  vim.cmd("colorscheme " .. M.theme)
  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
end

-- configure the kanagawa theme
M.kanagawa_setup = function()
  require("kanagawa").setup({
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = { bold = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = { bold = true },
    variablebuiltinStyle = { italic = true },
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    dimInactive = true,
    overrides = function(colors)
      local palette = colors.palette
      local theme = colors.theme
      return {
        htmlH1 = {
          fg = palette.peachRed,
          bold = true,
        },
        htmlH2 = {
          fg = palette.roninYellow,
          bold = true,
        },
        htmlH3 = {
          fg = palette.autumnYellow,
          bold = true,
        },
        htmlH4 = {
          fg = palette.autumnGreen,
          bold = true,
        },
        Todo = {
          fg = palette.fujiWhite,
          bg = palette.samuraiRed,
          bold = true,
        },
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        HighLightLineMatches = {
          bg = palette.winterYellow,
        },
        -- TelescopeTitle = { fg = theme.ui.special, bold = true },
        TelescopePreviewTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        TelescopePromptTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        TelescopeResultsTitle = { fg = palette.sumiInk0, bg = palette.sakuraPink },
        WinSeparator = { fg = palette.lightBlue },
        InclineNormal = { fg = palette.sumiInk1, bg = palette.waveRed },
        InclineNormalNC = { fg = palette.winterBlue, bg = palette.sakuraPink },
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
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
