local lualine = require("lualine")
local status_helper = require("lib.status")

local conditions = status_helper.conditions
local colors = status_helper.colors

local set_theme = function()
  local new_colors = status_helper.set_palette()
  return {
    normal = {
      a = { fg = new_colors.active_buffer, bg = new_colors.bg },
      b = { fg = new_colors.fg, bg = new_colors.black },
      c = { fg = new_colors.black, bg = new_colors.black },
    },
    inactive = {
      a = { fg = new_colors.inactive_buffer, bg = new_colors.bg },
      b = { fg = new_colors.fg, bg = new_colors.black },
      c = { fg = new_colors.black, bg = new_colors.black },
    },
  }
end

-- local breadcrump_sep = " ⟩ "
local separator_left = " ░▒▓"
local separator_right = "▓▒░ "

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
    -- lualine_a = {
    --   {
    --     "filename",
    --     path = 1,
    --     separator = vim.trim(breadcrump_sep),
    --     fmt = function(str)
    --       local path_separator = package.config:sub(1, 1)
    --       return str:gsub(path_separator, breadcrump_sep)
    --     end,
    --   },
    --   {
    --     "aerial",
    --     sep = breadcrump_sep,
    --     cond = function()
    --       for _, v in ipairs(vim.g.enable_treesitter_ft) do
    --         if v == vim.bo.filetype then
    --           return true
    --         end
    --       end
    --       return false
    --     end,
    --   },
    -- },
  },
  inactive_winbar = {
    --   lualine_a = {
    --     {
    --       "filename",
    --       path = 1, -- relative path
    --       separator = vim.trim(breadcrump_sep),
    --       fmt = function(str)
    --         local path_separator = package.config:sub(1, 1)
    --         return str:gsub(path_separator, breadcrump_sep)
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

-- insert_left({
--   function()
--     return " "
--   end,
--   color = { fg = colors.fg, bg = colors.bg },
-- })

insert_left({
  function()
    local mode = status_helper.get_mode()
    return " " .. mode.icon .. mode.alias .. " "
  end,
  color = { fg = status_helper.get_mode_color(), bg = colors.bg },
})

-- insert_left({
--   function()
--     return "▓"
--   end,
--   color = { fg = colors.bg },
-- })

insert_left({
  function()
    return separator_right
  end,
  color = { fg = colors.bg },
})

-- mode panel end}

-- {information panel start
insert_left({
  function()
    return separator_left
  end,
  color = { fg = colors.bg },
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
  color = { fg = colors.fg, bg = colors.bg },
  padding = { left = 0, right = 1 },
})

insert_left({
  "diff",
  source = status_helper.diff_source,
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = function()
    return not conditions.check_special_buffer() and conditions.check_git_workspace()
  end,
  color = { fg = colors.fg, bg = colors.bg },
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

insert_left({
  status_helper.get_file_icon,
  cond = function()
    return not conditions.check_special_buffer() and conditions.buffer_not_empty()
  end,
  color = {
    fg = status_helper.get_file_icon_color(),
    bg = colors.bg_alt,
  },
})

insert_left({
  status_helper.get_file_name,
  -- cond = conditions.has_file_type,
  color = { fg = colors.fg, bg = colors.bg_alt },
  padding = { left = 1, right = 1 },
})

insert_left({
  function()
    return separator_right
  end,
  color = { fg = colors.bg_alt },
})
-- left information panel end}

insert_right({
  function()
    return separator_left
  end,
  color = { fg = colors.bg_alt },
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
    for _, client in pairs(active_clients) do
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
  -- cond = conditions.checkwidth,
  color = { fg = colors.fg, bg = colors.bg_alt },
  padding = { left = 0, right = 1 },
})

insert_right({
  function()
    -- return ""
    return ""
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
