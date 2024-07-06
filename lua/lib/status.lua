local colors = require("lib.palette").colors
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local special_buffer_list = vim.g.special_buffer_list or {}
-- speed up the lookup of special buffer type
for _, v in ipairs(special_buffer_list) do
  special_buffer_list[v] = true
end

local M = { special_buffer_list = special_buffer_list }

M.buffer_type_map = {
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

M.conditions = {
  has_file_type = function()
    return vim.bo.filetype ~= nil
  end,
  has_file_name = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  checkwidth = function()
    -- local squeeze_width = vim.fn.winwidth(0) / 2
    -- we just care about global width when last_status = 3
    local squeeze_width = vim.o.columns / 2
    return squeeze_width > 40
  end,
  check_git_workspace = function()
    -- we only care about normal files
    if vim.bo.buftype ~= "" then
      return false
    end
    ---@type string
    local current_dir = vim.fn.expand("%:p:h")
    -- search for .git folder until home dir
    local gitdir = vim.fs.find(
      ".git",
      { path = current_dir, upward = true, stop = vim.env.HOME, type = "directory" }
    )
    -- local gitdir = vim.fn.finddir(".git", current_dir .. ";" .. vim.env.HOME)
    return gitdir and #gitdir > 0
  end,
  check_special_buffer = function()
    return special_buffer_list[vim.bo.filetype] ~= nil
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

M.get_mode = function()
  local vim_mode = vim.fn.mode()
  local icon = mode_icons[vim_mode] or " "
  local alias = mode_alias[vim_mode] or vim_mode
  return { icon = icon, alias = alias }
end

M.get_mode_color = function()
  local vim_mode = vim.fn.mode()
  return mode_color[vim_mode]
end

M.diff_source = function()
  local gitsigns = vim.b.gitsigns_status_dict
  local source = {}
  if gitsigns then
    source = {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
  return source
end

local function get_file_info()
  return vim.fn.expand("%:t"), vim.fn.expand("%:e")
end

M.get_file_icon = function()
  local icon = nil
  local f_name, f_extension = get_file_info()
  if has_devicons then
    icon = devicons.get_icon(f_name, f_extension, { default = true })
  elseif vim.fn.exists("*WebDevIconsGetFileTypeSymbol") == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol()
  end
  if icon == nil then
    icon = ""
  end
  return icon
end

M.get_file_icon_color = function()
  local f_name, f_ext = get_file_info()
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

M.get_file_name = function()
  local filetype = vim.bo.filetype
  local file = vim.fn.expand("%:t")
  local fname = ""
  if special_buffer_list[filetype] ~= nil then
    fname = M.buffer_type_map[filetype]
    if filetype == "help" or filetype == "man" then
      fname = fname .. "»" .. file
    end
    return fname
  end

  fname = file_with_icons(file)
  return fname
end

return M
