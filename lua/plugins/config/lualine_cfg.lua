local lualine = require("lualine")

local current_scheme = vim.g.colors_name
local colors = {
  bg_alt = "#592147",
  bg = "#2F3445",
  active_buffer = "#FFBBDD",
  inactive_buffer = "#AA7788",
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

local short_line_list = {
  "oil",
  "term",
  "nerdtree",
  "fugitive",
  "fugitiveblame",
  "DiffviewFiles",
  "qf",
  "help",
  "toggleterm",
  "alpha",
  "man",
}

local BufferTypeMap = {
  ["oil"] = " File Management",
  ["alpha"] = "󰡃 Dashboard",
  ["fugitive"] = " Fugitive",
  ["fugitiveblame"] = " Fugitive Blame",
  ["minimap"] = "Minimap",
  ["qf"] = "󰁨 Quick Fix",
  ["neoterm"] = " NeoTerm",
  ["toggleterm"] = " ToggleTerm",
  ["help"] = "󰞋 Help",
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
    for _, v in ipairs(short_line_list) do
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

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      normal = {
        a = { fg = colors.active_buffer, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.black, bg = colors.black },
      },
      inactive = {
        a = { fg = colors.inactive_buffer, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.black, bg = colors.black },
      },
    },
    globalstatus = true,
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
    --   lualine_a = {
    --     {
    --       "filename",
    --       symbols = {
    --         modified = "", -- Text to show when the file is modified.
    --         readonly = "", -- Text to show when the file is non-modifiable or readonly.
    --         unnamed = "[No Name]", -- Text to show for unnamed buffers.
    --         newfile = "[New]", -- Text to show for newly created file before first write
    --       },
    --       cond = function()
    --         return conditions.check_multiple_win() and not conditions.check_special_buffer()
    --       end,
    --     },
    --   },
    --   lualine_z = {
    --     {
    --       "tabs",
    --       cond = function()
    --         return vim.fn.tabpagenr("$") > 1
    --       end,
    --     },
    --   },
    -- },
    -- inactive_winbar = {
    --   lualine_a = {
    --     {
    --       "filename",
    --       symbols = {
    --         modified = "", -- Text to show when the file is modified.
    --         readonly = "", -- Text to show when the file is non-modifiable or readonly.
    --         unnamed = "[No Name]", -- Text to show for unnamed buffers.
    --         newfile = "[New]", -- Text to show for newly created file before first write
    --       },
    --       cond = function()
    --         return conditions.check_multiple_win() and not conditions.check_special_buffer()
    --       end,
    --     },
    --   },
    --   lualine_z = {
    --     {
    --       "tabs",
    --       cond = function()
    --         return vim.fn.tabpagenr("$") > 1
    --       end,
    --     },
    --   },
  },
}

-- Inserts a component in lualine_c at left section
local function insert_left(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_b, component)
end

-- Inserts a component in lualine_x at right section
local function insert_right(component)
  if component.padding == nil then
    component.padding = 0
  end
  table.insert(config.sections.lualine_y, component)
end

-----------------------------------------------------
----------------- start insert ----------------------
-----------------------------------------------------
-- { mode panel start
local separator_left = "░▒▓"
local separator_right = "▓▒░"

insert_left({
  function()
    return " "
  end,
  color = { fg = colors.fg, bg = colors.bg },
})

local function get_mode_color()
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
  return { fg = mode_color[vim_mode] }
end

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
  color = get_mode_color,
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
  color = get_mode_color,
  padding = { left = 0, right = 1 },
})

insert_left({
  function()
    return separator_right .. " "
  end,
  color = { fg = colors.bg, bg = colors.black },
})

-- mode panel end}

-- {information panel start
insert_left({
  function()
    return " " .. separator_left
  end,
  color = { fg = colors.bg, bg = colors.black },
})

insert_left({
  function()
    return "▓"
  end,
  color = { fg = colors.bg, bg = colors.bg },
})

insert_left({
  "branch",
  icon = { "", color = { fg = colors.orange, bg = colors.bg } },
  cond = function()
    return not conditions.check_special_buffer() and conditions.check_git_workspace()
  end,
  color = { colors.fg, colors.bg },
  padding = { left = 0, right = 1 },
})

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

insert_left({
  "diff",
  source = diff_source,
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = function()
    return not conditions.check_special_buffer() and conditions.check_git_workspace()
  end,
  padding = { left = 0, right = 1 },
})

insert_left({
  "diagnostics",
  icon = { "", color = { fg = colors.yellow, gui = "bold" } },
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
    color_hint = { fg = colors.white },
  },
  update_in_insert = false,
  cond = conditions.checkwidth,
  padding = { left = 0, right = 1 },
})

insert_left({
  function()
    return ""
  end,
  color = { fg = colors.bg, bg = colors.bg_alt },
})

insert_left({
  function()
    return " "
  end,
  color = { fg = colors.bg_alt, bg = colors.bg_alt },
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
  return icon
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

local function buffer_is_readonly()
  if vim.bo.filetype == "help" then
    return false
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
  for _, v in ipairs(short_line_list) do
    if v == vim.bo.filetype then
      return BufferTypeMap[v]
    end
  end

  local file = vim.fn.expand("%:t")
  local fname = file_with_icons(file)
  return fname
end

insert_left({
  get_file_icon,
  cond = function()
    return not conditions.check_special_buffer() and conditions.buffer_not_empty()
  end,
  color = {
    fg = get_file_icon_color(),
    bg = colors.bg_alt,
  },
})

insert_left({
  get_file_name,
  -- cond = conditions.has_file_type,
  color = { fg = colors.fg, bg = colors.bg_alt },
  padding = { left = 1, right = 1 },
})

insert_left({
  function()
    return separator_right .. " "
  end,
  color = { fg = colors.bg_alt, bg = colors.black },
})
-- left information panel end}

insert_right({
  function()
    return " " .. separator_left
  end,
  color = { fg = colors.bg_alt, bg = colors.black },
})

insert_right({
  function()
    return "▓"
  end,
  color = { fg = colors.bg_alt, bg = colors.bg_alt },
})

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "LspProgressStatusUpdated",
  group = "lualine_augroup",
  callback = require("lualine").refresh,
})

insert_right({
  function()
    local progress = require("lsp-progress").progress({
      format = function(messages)
        local max_size = 40
        if #messages > 0 then
          local progress = table.concat(messages, ";")
          if #progress > max_size then
            -- local pos = progress:sub(max_size, max_size + 10):match("^.*()%%")
            -- progress = progress:sub(1, pos and max_size + pos or max_size) .. "…"
            progress = progress:sub(1, max_size) .. "…"
          end

          progress = progress:gsub("[%%]+", "%%%%") -- fix issue with single % symbol
          return progress
        else
          return nil
        end
      end,
    })

    local active_clients = vim.lsp.buf_get_clients()
    -- local client_count = #active_clients
    local client_names = {}
    for i, client in pairs(active_clients) do
      if client and client.name ~= "" then
        table.insert(client_names, client.name)
      end
    end
    local status = " [" .. table.concat(client_names, ", ") .. "]"

    if progress ~= nil then
      return progress .. " " .. status
    else
      return status
    end
  end,
  cond = function()
    local active_clients = vim.lsp.buf_get_clients()
    return next(active_clients) ~= nil and conditions.checkwidth()
  end,
  color = { fg = colors.fg, bg = colors.bg_alt },
  padding = { left = 0, right = 1 },
})

insert_right({
  function()
    return ""
  end,
  color = { fg = colors.bg_alt, bg = colors.bg },
  padding = 0,
})

insert_right({
  function()
    local tabpagenr = vim.fn.tabpagenr("$")
    if tabpagenr > 1 then
      local curr_tab = vim.api.nvim_tabpage_get_number(0)
      return "Tab " .. curr_tab .. "/" .. tabpagenr
    else
      return ""
    end
  end,
  icon = { "󰠵", color = { fg = colors.purple, bg = colors.bg } },
  color = { fg = colors.fg, bg = colors.bg },
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

insert_right({
  function()
    local line = vim.fn.line(".")
    local column = vim.fn.col(".")
    return string.format("%3d:%2d", line, column)
  end,
  icon = "",
  -- separator_highlight = { colors.green, colors.black },
  color = { fg = colors.green, bg = colors.bg },
  padding = { left = 1, right = 1 },
})

insert_right({
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
  color = { fg = colors.cyan, bg = colors.bg },
  padding = { left = 0, right = 1 },
})

insert_right({
  function()
    return vim.bo.fileformat:upper()
  end,
  icon = "",
  cond = conditions.checkwidth,
  color = { fg = colors.blue, bg = colors.bg },
})

insert_right({
  function()
    return " "
  end,
  color = { fg = colors.fg, bg = colors.bg },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
