-- scroll target buffer to end (set cursor to last line)
local function scroll_to_end(bufnr)
  local cur_win = vim.api.nvim_get_current_win()

  -- switch to buf and set cursor
  vim.api.nvim_buf_call(bufnr, function()
    local target_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(target_win)

    -- local target_line = vim.tbl_count(vim.api.nvim_buf_get_lines(0, 0, -1, true))
    local target_line = vim.fn.line("$")
    vim.api.nvim_win_set_cursor(target_win, { target_line, 0 })
  end)

  -- return to original window
  vim.api.nvim_set_current_win(cur_win)
end

local function is_floating_win(winid)
  winid = winid or 0
  if vim.api.nvim_win_get_config(winid).zindex ~= nil then
    return true
  else
    return false
  end
end

-- WARN: this function is deplicate with the one in status.lua
local function not_special_buffer(ft)
  local special_buffer_list = vim.g.special_buffer_list or {}
  for _, v in ipairs(special_buffer_list) do
    if v == ft then
      return false
    end
  end
  return true
end

local function buffer_jump(direction)
  -- default to forward jump
  if direction ~= -1 then
    direction = 1
  end

  if is_floating_win() then
    -- don't jump in floating windows
    vim.notify("Cannot jump to other buffers from a floating window!", vim.log.levels.INFO)
    return
  end

  if not not_special_buffer(vim.bo.ft) then
    -- don't jump from special buffers
    vim.notify("Cannot jump to other buffers from a special buffer!", vim.log.levels.INFO)
    return
  end

  local buf_cur = vim.api.nvim_get_current_buf()

  -- get all valid buffers
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
  end, vim.api.nvim_list_bufs())

  local buf_num = #buffers
  if buf_num == 1 then
    vim.notify("There is only one buffer!", vim.log.levels.INFO)
  end
  local idx_cur = nil
  for i, buf_id in ipairs(buffers) do
    if buf_id == buf_cur then
      idx_cur = i
      break
    end
  end

  local buf_next = nil
  local buf_idx = nil
  for i = 1, buf_num do
    -- vim.print({ cur = idx_cur, next = idx_cur + i * direction, num = buf_num })
    buf_idx = (idx_cur + i * direction) % buf_num
    if buf_idx == 0 then
      buf_next = buffers[buf_num]
    else
      buf_next = buffers[buf_idx]
    end
    local ft = vim.api.nvim_buf_get_option(buf_next, "filetype")
    if ft and not_special_buffer(ft) then
      vim.api.nvim_set_current_buf(buf_next)
      return
    end
  end
end

local function is_cmdline()
  local cmdwintype = vim.fn.getcmdwintype()
  return cmdwintype ~= ""
end

-- alias can help create new vim command.
-- @param cmd The user command
-- @param repl The actual command or function
-- @param opts The table of options
local function alias(cmd, repl, opts)
  local options = {
    bang = false,
  }
  if opts and type(opts) == "table" then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_create_user_command(cmd, repl, options)
end

return {
  scroll_to_end = scroll_to_end,
  alias = alias,
  is_cmdline = is_cmdline,
  buffer_jump = buffer_jump,
}
