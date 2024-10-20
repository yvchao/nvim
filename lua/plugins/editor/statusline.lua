local status_helper = require("lib.status")
local palette = require("lib.palette")

local conditions = status_helper.conditions

local set_theme = function()
  local new_colors = palette.colors
  return {
    normal = {
      a = { fg = new_colors.yellow, bg = new_colors.bg },
      b = { fg = new_colors.fg, bg = new_colors.bg },
      c = { fg = new_colors.fg, bg = new_colors.bg_alt },
    },
    insert = {
      a = { fg = new_colors.green, bg = new_colors.bg },
    },
    visual = {
      a = { fg = new_colors.blue, bg = new_colors.bg },
    },
    command = {
      a = { fg = new_colors.cyan, bg = new_colors.bg },
    },
    inactive = {
      a = { fg = new_colors.fg, bg = new_colors.bg },
      b = { fg = new_colors.fg_alt, bg = new_colors.bg },
      c = { fg = new_colors.fg, bg = new_colors.bg_alt },
    },
  }
end

local breadcrump_sep = " ⟩ "
local separator_left = " "
local separator_right = " "

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = set_theme,
    globalstatus = true,
    disabled_filetypes = {
      statusline = {},
      winbar = vim.g.special_buffer_list or {},
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
  winbar = {
    lualine_b = {
      {
        "filename",
        path = 1,
        separator = vim.trim(breadcrump_sep),
        fmt = function(str)
          local path_separator = package.config:sub(1, 1)
          return str:gsub(path_separator, breadcrump_sep)
        end,
      },
      {
        "aerial",
        sep = breadcrump_sep,
      },
    },
  },
  inactive_winbar = {
    lualine_b = {
      {
        "filename",
        path = 1, -- relative path
        separator = vim.trim(breadcrump_sep),
        fmt = function(str)
          local path_separator = package.config:sub(1, 1)
          return str:gsub(path_separator, breadcrump_sep)
        end,
      },
    },
  },
}

-- Inserts a component in lualine_a at left section
local function insert_mode(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_a, component)
end

-- Inserts a component in lualine_b at left section
local function insert_info_left(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_b, component)
end

local function insert_info_right(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_y, component)
end

local function insert_left(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_c, component)
end

local function insert_right(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_x, component)
end
-----------------------------------------------------
----------------- start insert ----------------------
-----------------------------------------------------
-- { mode panel start

insert_mode({
  function()
    local mode = status_helper.get_mode()
    return mode.icon .. mode.alias
  end,
  padding = { left = 1, right = 0 },
})

insert_mode({
  function()
    return "⦀"
  end,
  padding = { left = 1, right = 1 },
  color = { fg = "bg" },
})
-- mode panel end}
--
-- -- {information panel start
-- insert_left({
--   function()
--     return separator_left
--   end,
--   color = { fg = palette.bg() },
-- })

insert_info_left({
  function()
    return "󰻀 "
  end,
  cond = function()
    return not conditions.check_git_workspace()
  end,
  -- color = { fg = palette.fg(), bg = palette.bg() },
  padding = { left = 0, right = 1 },
})

insert_info_left({
  "branch",
  icon = { " ", color = { fg = palette.get_color("orange") } },
  cond = conditions.check_git_workspace,
  -- color = { fg = palette.fg(), bg = palette.bg() },
  padding = { left = 0, right = 1 },
})

insert_info_left({
  "diff",
  source = status_helper.diff_source,
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = palette.get_color("green") },
    modified = { fg = palette.get_color("orange") },
    removed = { fg = palette.get_color("red") },
  },
  cond = conditions.check_git_workspace,
  -- color = { fg = palette.fg(), bg = palette.bg() },
  padding = { left = 0, right = 1 },
})

insert_left({
  function()
    return status_helper.get_file_icon() .. " "
  end,
  cond = function()
    return not conditions.check_special_buffer() and conditions.has_file_name()
  end,
  color = {
    fg = palette.get_color("blue"),
    bg = palette.get_color("bg_status"),
  },
  padding = { left = 1, right = 0 },
})

insert_left({
  status_helper.get_file_name,
  color = {
    fg = palette.get_color("fg_status"),
    bg = palette.get_color("bg_status"),
  },
  padding = { left = 1, right = 1 },
})

insert_left({
  function()
    return separator_right
  end,
  color = {
    fg = palette.get_color("bg_status"),
  },
})
-- left information panel end}

insert_right({
  function()
    return separator_left
  end,
  color = {
    fg = palette.get_color("bg_status"),
  },
})

-- insert_right({
--   function()
--     return " "
--   end,
--   cond = function()
--     local active_clients = vim.lsp.get_clients()
--     return next(active_clients) == nil
--   end,
--   color = { bg = palette.bg_alt() },
--   padding = { left = 0, right = 1 },
-- })

insert_right({
  function()
    local active_clients = vim.lsp.get_clients()
    if next(active_clients) ~= nil then
      return " "
    else
      return " "
    end
  end,
  cond = conditions.checkwidth,
  color = {
    fg = palette.get_color("fg_status"),
    bg = palette.get_color("bg_status"),
  },
  on_click = function(clicknr, button, modifier)
    if button == "l" and vim.fn.exists(":LspInfo") == 2 and vim.bo.filetype ~= "lspinfo" then
      vim.cmd("LspInfo")
    end
  end,
  padding = { left = 0, right = 1 },
})

insert_right({
  "diagnostics",
  -- icon = { "", color = { fg = palette.get_color("yellow"), gui = "bold" } },
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
  colored = true,
  diagnostics_color = {
    error = { fg = palette.get_color("red") },
    warn = { fg = palette.get_color("yellow") },
    info = { fg = palette.get_color("dimblue") },
    hint = { fg = palette.get_color("dimblue") },
  },
  update_in_insert = false,
  cond = function()
    return vim.diagnostic.get_next() ~= nil
  end,
  color = {
    fg = palette.get_color("fg_status"),
    bg = palette.get_color("bg_status"),
  },
  padding = { left = 0, right = 1 },
})

insert_info_right({
  function()
    local tabpagenr = vim.fn.tabpagenr("$")
    if tabpagenr > 1 then
      local curr_tab = vim.api.nvim_tabpage_get_number(0)
      return "Tab " .. curr_tab .. "/" .. tabpagenr
    end
  end,
  icon = { "󰠵", color = { fg = palette.get_color("purple") } },
  padding = { left = 1, right = 0 },
  cond = function()
    return vim.fn.tabpagenr("$") > 1
  end,
  on_click = function(clicknr, button, modifier)
    if button == "l" then
      vim.cmd("tabnext")
    elseif button == "r" then
      vim.cmd("tabprevious")
    end
  end,
})

insert_info_right({
  function()
    local line = vim.fn.line(".")
    local column = vim.fn.col(".")
    return string.format("%3d:%2d", line, column)
  end,
  icon = "",
  -- separator_highlight = { colors.green, colors.black },
  color = { fg = palette.get_color("green") },
  padding = { left = 1, right = 1 },
})

insert_info_right({
  function()
    local current_line = vim.fn.line(".")
    local total_line = vim.fn.line("$")
    if current_line == 1 then
      return "Top"
    elseif current_line == vim.fn.line("$") then
      return "Bot"
    end
    local ratio, _ = math.modf((current_line / total_line) * 100)
    return string.format("%2d", ratio) .. "%%"
  end,
  icon = "",
  cond = conditions.checkwidth,
  color = { fg = palette.get_color("cyan") },
  padding = { left = 0, right = 1 },
})

insert_info_right({
  function()
    return vim.bo.fileformat:upper()
  end,
  icon = "",
  cond = conditions.checkwidth,
  padding = { left = 0, right = 1 },
  color = { fg = palette.get_color("blue") },
})

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- lualine optimization
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = config,
    event = "UIEnter",
  },
}
