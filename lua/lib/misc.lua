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
    return vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_get_option_value("buflisted", { buf = buf })
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
  if idx_cur == nil then
    vim.notify("Current buffer is invalid!", vim.log.levels.INFO)
    return
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
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_next })
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

-- ---@return string|nil
-- local function get_visual_text()
--   local _, start_row, start_col, _ = vim.fn.getpos("'<")
--   local _, end_row, end_col, _ = vim.fn.getpos("'>")
--   if start_row ~= end_row then
--     vim.notify("Only single line text is valid for grep!", vim.log.levels.INFO)
--     return nil
--   end
--
--   -- or use api.nvim_buf_get_lines
--   ---@cast start_row integer
--   local line = vim.fn.getline(start_row)
--   ---@cast start_col integer
--   return line:sub(start_col, end_col)
-- end

-- local function resolve()
--   local current_file = vim.fn.expand("%:p")
--   local current_dir
--   -- if file is a symlinks
--   if vim.fn.getftype(current_file) == "link" then
--     local real_file = vim.fn.resolve(current_file)
--     current_dir = vim.fn.fnamemodify(real_file, ":h")
--   else
--     current_dir = vim.fn.expand("%:p:h")
--   end
--   return current_dir
-- end

return {
  scroll_to_end = scroll_to_end,
  alias = alias,
  is_cmdline = is_cmdline,
  buffer_jump = buffer_jump,
}
