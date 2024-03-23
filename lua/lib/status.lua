local current_scheme = vim.g.colors_name

local special_buffer_list = vim.g.special_buffer_list or {}

local set_palette = function()
  local colors = {
    bg_alt = "#592147",
    bg = "#2F3445",
    active_buffer = "#FFBBDD",
    inactive_buffer = "#BB88AA",
    fg = "#F5DBDB",
    black = "#16161D",
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
  if current_scheme == "kanagawa" then
    if vim.o.background == "light" then
      colors.bg = "#C8C093"
      colors.black = "#f2ecbc"
      colors.active_buffer = "#363646"
      colors.inactive_buffer = "#54546D"
    else
      colors.bg = "#223249"
      colors.black = "#1F1F28"
    end
  elseif current_scheme == "everforest" then
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
  return colors
end

local colors = set_palette()

local BufferTypeMap = {
  ["oil"] = "  File Management",
  ["minifiles"] = "  File Management",
  ["starter"] = "󰡃 Dashboard",
  ["fugitive"] = " Fugitive",
  ["gitcommit"] = " Commit Message",
  ["fugitiveblame"] = " Fugitive Blame",
  ["minimap"] = "Minimap",
  ["qf"] = "󰁨 Quick Fix",
  ["neoterm"] = " NeoTerm",
  ["toggleterm"] = " ToggleTerm",
  ["help"] = "󰞋 Help",
  ["nredir"] = " Cmd Output",
  ["git"] = " Git",
  ["DiffviewFiles"] = " Diff View",
  ["DapBreakpoint"] = " Dap Breakpoints",
  ["dap-repl"] = " Dap REPL",
  ["man"] = "󱁯 Manual",
}

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
    -- local squeeze_width = vim.fn.winwidth(0) / 2
    local squeeze_width = vim.o.columns / 2
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
    -- search for .git folder until home dir
    local gitdir = vim.fn.finddir(".git", current_dir .. ";" .. vim.env.HOME)
    return gitdir and #gitdir > 0
  end,
  check_special_buffer = function()
    for _, v in ipairs(special_buffer_list) do
      if v == vim.bo.filetype then
        return true
      end
    end
    return false
  end,
  check_multiple_win = function()
    local wins = vim.api.nvim_list_wins()
    local winnr = 0
    for _, id in ipairs(wins) do
      if vim.api.nvim_win_get_config(id).relative == "" then
        winnr = winnr + 1
      end
    end
    return winnr > 1
  end,
}

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
local mode_alias = {
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
local mode_icons = {
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

local function get_mode()
  local vim_mode = vim.fn.mode()
  local icon = mode_icons[vim_mode] or " "
  local alias = mode_alias[vim_mode] or vim_mode
  return { icon = icon, alias = alias }
end

local function get_mode_color()
  local vim_mode = vim.fn.mode()
  return mode_color[vim_mode]
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function get_file_info()
  return vim.fn.expand("%:t"), vim.fn.expand("%:e")
end

local function get_file_icon()
  local icon = nil
  local f_name, f_extension = get_file_info()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    icon = devicons.get_icon(f_name, f_extension, { default = true })
  elseif vim.fn.exists("*WebDevIconsGetFileTypeSymbol") == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol()
  end
  if icon == nil then
    icon = ""
  end
  return icon
end

local function get_file_icon_color()
  local f_name, f_ext = get_file_info()

  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local icon, iconhl = devicons.get_icon(f_name, f_ext)
    if icon ~= nil then
      return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
    end
  end
end

local function buffer_is_readonly()
  if vim.bo.filetype == "help" then
    return true
  end
  return vim.bo.readonly
end

local function file_with_icons(file, modified_icon, readonly_icon)
  if vim.fn.empty(file) == 1 then
    file = "No Name"
  end

  modified_icon = modified_icon or ""
  readonly_icon = readonly_icon or ""

  if buffer_is_readonly() then
    file = readonly_icon .. " " .. file
  end

  if vim.bo.modifiable and vim.bo.modified then
    file = file .. " " .. modified_icon
  end

  return file
end

local function get_file_name()
  for _, v in ipairs(special_buffer_list) do
    if v == vim.bo.filetype then
      return BufferTypeMap[v]
    end
  end

  local file = vim.fn.expand("%:t")
  local fname = file_with_icons(file)
  return fname
end

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = set_palette,
-- })

return {
  conditions = conditions,
  colors = colors,
  set_palette = set_palette,
  get_mode_color = get_mode_color,
  get_mode = get_mode,
  get_file_name = get_file_name,
  get_file_icon = get_file_icon,
  get_file_icon_color = get_file_icon_color,
  diff_source = diff_source,
}
