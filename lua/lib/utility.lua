local M = {}

--- Create a menu from a table
---@param option_table table
---@param prompt string
M.create_menu = function(option_table, prompt)
  local option_names = {}
  local n = 1
  for k, _ in pairs(option_table) do
    option_names[n] = k
    n = n + 1
  end

  local menu = function()
    vim.ui.select(option_names, {
      prompt = prompt or "Select an option",
      format_item = function(choice)
        return choice
      end,
    }, function(choice)
      local action = option_table[choice]
      -- When user inputs ESC or q, don't take any actions
      if action ~= nil then
        if type(action) == "string" then
          vim.cmd(action)
        elseif type(action) == "function" then
          action()
        end
      end
    end)
  end
  return menu
end

M.check_memory_usage = function()
  local nsn = vim.api.nvim_get_namespaces()

  local counts = {}

  for name, ns in pairs(nsn) do
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local count = #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
      if count > 0 then
        counts[#counts + 1] = {
          name = name,
          buf = buf,
          count = count,
          ft = vim.bo[buf].ft,
        }
      end
    end
  end
  table.sort(counts, function(a, b)
    return a.count > b.count
  end)
  vim.print(counts)
end

return M
