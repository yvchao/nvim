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
end

-- configure the deus theme
M.deus_setup = function()
  vim.g.deus_background = "hard"
  apply()
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
      return {
        htmlH1 = {
          fg = colors.palette.peachRed,
          bold = true,
        },
        htmlH2 = {
          fg = colors.palette.roninYellow,
          bold = true,
        },
        htmlH3 = {
          fg = colors.palette.autumnYellow,
          bold = true,
        },
        htmlH4 = {
          fg = colors.palette.autumnGreen,
          bold = true,
        },
        Todo = {
          fg = colors.palette.fujiWhite,
          bg = colors.palette.samuraiRed,
          bold = true,
        },
        Pmenu = {
          bg = colors.palette.sumiInk1,
        },
        HighLightLineMatches = {
          bg = colors.palette.winterYellow,
        },
      }
    end,
  })
  apply()
end

-- configure the nightfox theme
M.nightfox_setup = function()
  require("nightfox").setup({
    options = {
      -- Compiled file's destination location
      compile_path = vim.fn.stdpath("cache") .. "/nightfox",
      compile_file_suffix = "_compiled", -- Compiled file suffix
      transparent = false, -- Disable setting background
      terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
      dim_inactive = true, -- Non focused panes set to alternative background
      styles = { -- Style to be applied to different syntax groups
        comments = "italic", -- Value is any valid attr-list value `:help attr-list`
        functions = "bold",
        keywords = "italic",
        numbers = "NONE",
        strings = "NONE",
        types = "italic,bold",
        variables = "NONE",
      },
    },
    groups = {
      HighLightLineMatches = {
        bg = "#FFDE83",
      },
    },
  })
  apply()
end

-- configure the nightfox theme
M.github_setup = function()
  -- trim the prefix text
  local theme = M.theme:gsub("github_", "")
  require("github-theme").setup({
    theme_style = theme,
    function_style = "bold",
    comment_style = "italic",
    keyword_style = "italic",
    variable_style = "NONE",
    sidebars = { "qf", "vista_kind", "terminal", "packer", "NvimTree" },

    -- Overwrite the highlight groups
    overrides = function(_)
      return {
        HighLightLineMatches = {
          bg = "#FFDE83",
        },
      }
    end,
  })
  -- this plugin will setup colorscheme for us
  -- apply()
end

-- return the configuration for load condition
return M
