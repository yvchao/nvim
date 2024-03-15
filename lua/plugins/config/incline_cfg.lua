local special_buffer_list = vim.g.special_buffer_list or {}

---Escape % in str so it doesn't get picked as stl item.
---@param str string
---@return string
local function stl_escape(str)
  if type(str) ~= "string" then
    return str
  end
  local safe_str, _ = str:gsub("%%", "%%%%")
  return safe_str
end

---@param symbol table
---@param is_icon boolean
---@return string|nil
local function get_hl_group(symbol, is_icon)
  return require("aerial.highlight").get_highlight(symbol, is_icon, false)
end

local function insert_symbols(parts, symbols, depth, separator, icons_enabled)
  local n_symbols = #symbols
  depth = depth or n_symbols

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for i, symbol in ipairs(symbols) do
    if icons_enabled then
      local hl_group = get_hl_group(symbol, true)
      table.insert(parts, { symbol.icon, group = hl_group })
    end
    local hl_group = get_hl_group(symbol, false)
    table.insert(parts, { stl_escape(symbol.name), group = hl_group })
    if i < n_symbols then
      table.insert(parts, { separator, group = "NonText" })
    else
      table.insert(parts, { " | ", group = "NonText" })
    end
  end
  return parts
end

require("incline").setup({
  hide = {
    focused_win = false,
    only_win = false,
    cursorline = false,
  },
  ignore = {
    filetypes = special_buffer_list,
  },
  window = {
    padding = {
      left = 0,
      right = 0,
    },
    margin = {
      horizontal = 0,
      vertical = 1,
    },
  },
  render = function(props)
    local res = {}

    local breadcrump_sep = " ⟩ "
    local prefix = " "
    local suffix = " "
    local depth = -1
    local enable_icon = true

    table.insert(res, { prefix })

    if props.focused then
      local symbols = require("aerial").get_location({ exact = true })
      res = insert_symbols(res, symbols, depth, breadcrump_sep, enable_icon)
    end
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
    table.insert(res, { filename })

    if vim.api.nvim_buf_get_option(props.buf, "modified") then
      table.insert(res, { " [+]" })
    end
    table.insert(res, { suffix })
    return res
  end,
})
