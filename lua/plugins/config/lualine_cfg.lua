local lualine = require("lualine")

local current_scheme = vim.g.colors_name
local colors = {
  bg = "#2F3445",
  fg = "#8FBCBB",
  black = "#1F253A",
  grey = "#303030",
  yellow = "#E5C07B",
  cyan = "#70C0BA",
  dimblue = "#83A598",
  green = "#98C379",
  orange = "#FF8800",
  purple = "#C678DD",
  magenta = "#C858E9",
  blue = "#73BA9F",
  red = "#D54E53",
}

if current_scheme == "everforest" then
  colors.bg = "#282E2C"
  colors.black = "#222B28"
elseif current_scheme == "gruvbox" then
  colors.bg = "#261C00"
  colors.black = "#3A2300"
elseif current_scheme == "dawnfox" then
  colors.bg = "#898180"
  colors.black = "#625c5c"
elseif current_scheme:match("github_light[%l_]*") then
  local custom = {
    fg = "#24292f",
    bg = "#bbd6ee",
    black = "#9fc5e8",
    yellow = "#dbab09",
    cyan = "#0598bc",
    green = "#28a745",
    orange = "#d18616",
    magenta = "#5a32a3",
    purple = "#5a32a3",
    blue = "#0366d6",
    red = "#d73a49",
  }

  -- merge custom color to default
  colors = vim.tbl_deep_extend("force", {}, colors, custom)
end

local conditions = {
  has_file_type = function()
    local f_type = vim.bo.filetype
    if not f_type then
      return false
    end
    return true
  end,
  buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
      return true
    end
    return false
  end,
  checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 50 then
      return true
    end
    return false
  end,
  check_git_workspace = function()
    if vim.bo.buftype == "terminal" then
      return false
    end
    local current_file = vim.fn.expand("%:p")
    local current_dir
    -- if file is a symlinks
    if vim.fn.getftype(current_file) == "link" then
      local real_file = vim.fn.resolve(current_file)
      current_dir = vim.fn.fnamemodify(real_file, ":h")
    else
      current_dir = vim.fn.expand("%:p:h")
    end
    local gitdir = vim.fn.finddir(".git", current_dir .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #current_dir
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.black } },
      inactive = {
        c = { fg = colors.black, bg = colors.black },
      },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function insert_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function insert_right(component)
  table.insert(config.sections.lualine_x, component)
end

-----------------------------------------------------
----------------- start insert ----------------------
-----------------------------------------------------
-- { mode panel start

insert_left({
  function()
    return " "
  end,
  color = { fg = colors.fg, bg = colors.bg },
  padding = 0,
})

insert_left({
  function()
    local icons = {
      n = "󰁁 ",
      i = " ",
      c = " ",
      V = " ",
      [""] = " ",
      v = " ",
      C = " ",
      R = "󱚗 ",
      t = " ",
    }
    return icons[vim.fn.mode()]
  end,
  color = {
    fg = function()
      local mode_color = {
        n = colors.yellow,
        i = colors.green,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.purple,
        Rv = colors.purple,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }
      local vim_mode = vim.fn.mode()
      return mode_color[vim_mode]
    end,
  },
  padding = { right = 0, left = 1 },
})

insert_left({
  function()
    -- auto change color according the vim mode
    local alias = {
      n = "N",
      i = "I",
      c = "C",
      V = "VL",
      [""] = "V",
      v = "V",
      C = "C",
      ["r?"] = ":CONFIRM",
      rm = "--MORE",
      R = "R",
      Rv = "R&V",
      s = "S",
      S = "S",
      ["r"] = "HIT-ENTER",
      [""] = "SELECT",
      t = "T",
      ["!"] = "SH",
    }
    local vim_mode = vim.fn.mode()
    -- vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim_mode])
    return alias[vim_mode]
  end,
  padding = 0,
})

insert_left({
  function()
    return " "
  end,
  color = { fg = colors.bg, bg = colors.black },
  padding = 0,
})

-- mode panel end}

-- {information panel start
insert_left({
  function()
    return " "
  end,
  color = { fg = colors.bg, bg = colors.black },
  padding = 0,
})

insert_left({
  function()
    return " "
  end,
  cond = conditions.check_git_workspace,
  color = { fg = colors.orange, bg = colors.bg },
  padding = 0,
})

insert_left({
  "branch",
  cond = conditions.check_git_workspace,
  color = { colors.fg, colors.bg },
  padding = { left = 0, right = 1 },
})

insert_left({
  "diff",
  symbols = { added = "  ", modified = "  ", removed = "  " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.check_git_workspace,
  padding = 0,
})
--
insert_left({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = "  ", warn = "  ", info = "  ", hint = " 󰌶 " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
    color_hint = { fg = colors.white },
  },
  cond = conditions.checkwidth,
  padding = 0,
})

insert_left({
  function()
    return ""
  end,
  color = { fg = colors.bg, bg = colors.black },
  padding = 0,
})

insert_left({
  function()
    return " "
  end,
  color = { fg = colors.black, bg = colors.black },
  padding = 0,
})

local icon_colors = {
  Brown = "#905532",
  Aqua = "#3AFFDB",
  Blue = "#689FB6",
  Darkblue = "#44788E",
  Purple = "#834F79",
  Red = "#AE403F",
  Beige = "#F5C06F",
  Yellow = "#F09F17",
  Orange = "#D4843E",
  Darkorange = "#F16529",
  Pink = "#CB6F6F",
  Salmon = "#EE6E73",
  Green = "#8FAA54",
  Lightgreen = "#31B53E",
  White = "#FFFFFF",
  LightBlue = "#5fd7ff",
}

local icons = {
  Brown = { "" },
  Aqua = { "" },
  LightBlue = { "", "" },
  Blue = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  },
  Darkblue = { "", "" },
  Purple = { "", "", "", "", "" },
  Red = { "", "", "", "", "", "" },
  Beige = { "", "", "" },
  Yellow = { "", "", "λ", "", "" },
  Orange = { "", "" },
  Darkorange = { "", "", "", "", "" },
  Pink = { "", "" },
  Salmon = { "" },
  Green = { "", "", "", "", "", "" },
  Lightgreen = { "", "", "", "﵂" },
  White = { "", "", "", "", "", "" },
}

-- filetype or extensions : { colors ,icon}
local user_icons = {}

local function get_file_info()
  return vim.fn.expand("%:t"), vim.fn.expand("%:e")
end

local function get_file_icon()
  local icon = nil
  local f_name, f_extension = get_file_info()
  if user_icons[vim.bo.filetype] ~= nil then
    icon = user_icons[vim.bo.filetype][2]
  elseif user_icons[f_extension] ~= nil then
    icon = user_icons[f_extension][2]
  end
  if icon == nil then
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
      icon = devicons.get_icon(f_name, f_extension, { default = true })
    elseif vim.fn.exists("*WebDevIconsGetFileTypeSymbol") == 1 then
      icon = vim.fn.WebDevIconsGetFileTypeSymbol()
    end
  end
  if icon == nil then
    icon = ""
  end
  return icon .. " "
end

local function get_file_icon_color()
  local filetype = vim.bo.filetype
  local f_name, f_ext = get_file_info()

  if user_icons[filetype] ~= nil then
    return user_icons[filetype][1]
  end

  if user_icons[f_ext] ~= nil then
    return user_icons[f_ext][1]
  end

  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local icon, iconhl = devicons.get_icon(f_name, f_ext)
    if icon ~= nil then
      return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
    end
  end

  local icon = get_file_icon():match("%S+")
  for k, _ in pairs(icons) do
    if vim.fn.index(icons[k], icon) ~= -1 then
      return icon_colors[k]
    end
  end
end

insert_left({
  get_file_icon,
  cond = conditions.buffer_not_empty,
  color = {
    fg = get_file_icon_color(),
    bg = colors.black,
  },
  padding = 0,
})

insert_left({
  "filename",
  cond = conditions.has_file_type,
  color = { fg = colors.fg, bg = colors.black },
  padding = 0,
})

insert_left({
  function()
    return ""
  end,
  color = { fg = colors.black },
  padding = 0,
})
-- left information panel end}

insert_right({
  function()
    return " "
  end,
  color = { fg = colors.grey },
  padding = 0,
})

vim.api.nvim_create_augroup("lualine_augroup", { clear = false })
vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
  group = "lualine_augroup",
  callback = require("lualine").refresh,
})

insert_right({
  function()
    local status = require("lsp-progress").progress({
      format = function(messages)
        local active_clients = vim.lsp.get_active_clients()
        local client_count = #active_clients
        local status = " LSP[" .. client_count .. "]"
        if #messages > 0 then
          local progress = table.concat(messages, ";")
          if #progress > 47 then
            progress = progress:sub(1, 47) .. "..."
          end
          return progress .. " " .. status
        else
          return status
        end
      end,
      -- max_size = 80,
    })
    return status
  end,
  cond = function()
    local active_clients = vim.lsp.get_active_clients()
    return #active_clients >= 1 and conditions.checkwidth()
  end,
  color = { fg = colors.fg, bg = colors.grey },
  padding = { left = 0, right = 1 },
})

insert_right({
  function()
    return ""
  end,
  color = { fg = colors.grey, bg = colors.black },
  padding = 0,
})

insert_right({
  function()
    local line = vim.fn.line(".")
    local column = vim.fn.col(".")
    return string.format("%3d:%2d ", line, column)
  end,
  icon = " ",
  -- separator_highlight = { colors.green, colors.black },
  color = { fg = colors.green, bg = colors.black },
  cond = conditions.checkwidth,
  padding = 0,
})

insert_right({
  function()
    local current_line = vim.fn.line(".")
    local total_line = vim.fn.line("$")
    if current_line == 1 then
      return "Top "
    elseif current_line == vim.fn.line("$") then
      return "Bot "
    end
    local result, _ = math.modf((current_line / total_line) * 100)
    return "" .. result .. "%% "
  end,
  icon = "",
  cond = conditions.checkwidth,
  color = { fg = colors.cyan, bg = colors.black },
  padding = 0,
})

insert_right({
  function()
    return vim.bo.fileformat:upper()
  end,
  icon = "",
  cond = conditions.checkwidth,
  color = { fg = colors.blue, bg = colors.black },
  padding = 0,
})

insert_right({
  function()
    return " "
  end,
  color = { fg = colors.fg, bg = colors.black },
  padding = 0,
})
--
-- Now don't forget to initialize lualine
lualine.setup(config)
